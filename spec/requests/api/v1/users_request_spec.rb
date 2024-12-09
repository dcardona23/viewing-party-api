require "rails_helper"

RSpec.describe "Users API", type: :request do
  describe "Create User Endpoint" do
    let(:user_params) do
      {
        name: "Me",
        username: "its_me",
        password: "QWERTY123",
        password_confirmation: "QWERTY123"
      }
    end

    context "request is valid" do
      it "returns 201 Created and provides expected fields" do
        post api_v1_users_path, params: user_params, as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:id]).to eq(User.last.id.to_s)
        expect(json[:data][:attributes][:name]).to eq(user_params[:name])
        expect(json[:data][:attributes][:username]).to eq(user_params[:username])
        expect(json[:data][:attributes]).to have_key(:api_key)
        expect(json[:data][:attributes]).to_not have_key(:password)
        expect(json[:data][:attributes]).to_not have_key(:password_confirmation)
      end
    end

    context "request is invalid" do
      it "returns an error for non-unique username" do
        User.create!(name: "me", username: "its_me", password: "abc123")

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username has already been taken")
        expect(json[:status]).to eq(400)
      end

      it "returns an error when password does not match password confirmation" do
        user_params = {
          name: "me",
          username: "its_me",
          password: "QWERTY123",
          password_confirmation: "QWERT123"
        }

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Password confirmation doesn't match Password")
        expect(json[:status]).to eq(400)
      end

      it "returns an error for missing field" do
        user_params[:username] = ""

        post api_v1_users_path, params: user_params, as: :json
        json = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:bad_request)
        expect(json[:message]).to eq("Username can't be blank")
        expect(json[:status]).to eq(400)
      end
    end
  end

  describe "Get All Users Endpoint" do
    it "retrieves all users but does not share any sensitive data" do
      User.create!(name: "Tom", username: "myspace_creator", password: "test123")
      User.create!(name: "Oprah", username: "oprah", password: "abcqwerty")
      User.create!(name: "Beyonce", username: "sasha_fierce", password: "blueivy")

      get api_v1_users_path

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data].count).to eq(48)
      expect(json[:data][0][:attributes]).to have_key(:name)
      expect(json[:data][0][:attributes]).to have_key(:username)
      expect(json[:data][0][:attributes]).to_not have_key(:password)
      expect(json[:data][0][:attributes]).to_not have_key(:password_digest)
      expect(json[:data][0][:attributes]).to_not have_key(:api_key)
    end
  end

  describe "Retrieve User Profile Endpoint" do
    before(:each) do
      @user = User.create!(name: "Hank Williams", username: "hkw", password: "fwefw")
      @user2 = User.create!(name: "Baxter", username: "anchorman", password: "punt")
      @user3 = User.create!(name: "Loki", username: "sonofthor", password: "godofmischief")

      @viewing_party = ViewingParty.create!(
        name: "test", 
        start_time: "2025-02-01 01:00:00", 
        end_time: "2025-02-01 10:00:00", 
        movie_id: 11, 
        movie_title: "Inception", 
        user_id: @user.id, 
        invitees: [@user2, @user3]
        )

      @viewing_party2 = ViewingParty.create!(
        name: "test2", 
        start_time: "2025-02-01 01:00:00", 
        end_time: "2025-02-01 10:00:00", 
        movie_id: 11, 
        movie_title: "The Matrix", 
        user_id: @user.id, 
        invitees: [@user3]
        )

        @viewing_party2 = ViewingParty.create!(
        name: "test2", 
        start_time: "2025-02-01 01:00:00", 
        end_time: "2025-02-01 10:00:00", 
        movie_id: 11, 
        movie_title: "The Matrix", 
        user_id: @user2.id, 
        invitees: [@user, @user3]
        )
    end

    describe "happy paths" do
      it "retrieves a users profile" do
        get "/api/v1/users/#{@user.id}"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:id]).to eq(@user.id)
        expect(json[:data][:type]).to eq("user")
        expect(json[:data][:attributes]).to have_key(:name)
        expect(json[:data][:attributes][:name]).to eq("Hank Williams")
        expect(json[:data][:attributes]).to have_key(:username)
        expect(json[:data][:attributes][:username]).to eq("hkw")
        expect(json[:data][:attributes]).to have_key(:viewing_parties_hosted)
        expect(json[:data][:attributes][:viewing_parties_hosted]).to be_an(Array)
        expect(json[:data][:attributes][:viewing_parties_hosted][0][:host_id]).to eq(@user.id)
        expect(json[:data][:attributes][:viewing_parties_hosted][1][:host_id]).to eq(@user.id)
        expect(json[:data][:attributes]).to have_key(:viewing_parties_invited)
        expect(json[:data][:attributes][:viewing_parties_invited]).to be_an(Array)
        expect(json[:data][:attributes][:viewing_parties_invited][0][:host_id]).to eq(@user2.id)
      end
    end

    describe "sad paths" do
      it "returns an error if asked to retrieve a profile for an invalid user" do
        get "/api/v1/users/9999"

        json = JSON.parse(response.body, symbolize_names: true)
        expect(response).not_to be_successful

        expect(response).to have_http_status(:not_found)
        expect(json[:message]).to eq("Couldn't find User with 'id'=9999")
        expect(json[:status]).to eq("404")
      end
    end
  end
end
