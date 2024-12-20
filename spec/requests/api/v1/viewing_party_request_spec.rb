require "rails_helper"

RSpec.describe "Create Viewing Party Endpoint", type: :request do
  before(:each) do
    @user = User.create!(name: "Hank Williams", username: "hkw", password: "fwefw")
    @user2 = User.create!(name: "Baxter", username: "anchorman", password: "punt")
    @user3 = User.create!(name: "Loki", username: "sonofthor", password: "godofmischief")
  end

  describe "happy path" do
    it "can create a viewing party" do
      viewing_party_params = {
        name: "test",
        start_time: "2025-02-01 01:00:00",
        end_time: "2025-02-01 10:00:00",
        movie_id: 11,
        movie_title: "Inception",
        invitees: [@user2.id, @user3.id],
        user_id: @user.id
      }  

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/viewing_parties", headers: headers, params: JSON.generate(viewing_party_params)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(viewing_party_params[:name])
      expect(json[:data][:attributes]).to have_key(:start_time)
      expect(json[:data][:attributes][:start_time]).to include("2025-02-01")
      expect(json[:data][:attributes]).to have_key(:end_time)
      expect(json[:data][:attributes][:end_time]).to include("10:00:00")
      expect(json[:data][:attributes]).to have_key(:movie_id)
      expect(json[:data][:attributes][:movie_id]).to eq(viewing_party_params[:movie_id])
      expect(json[:data][:attributes]).to have_key(:movie_title)
      expect(json[:data][:attributes][:movie_title]).to eq(viewing_party_params[:movie_title])
    end

    it "can create a viewing party and skip invalid invitees" do
      viewing_party_params = {
        name: "test",
        start_time: "2025-02-01 01:00:00",
        end_time: "2025-02-01 10:00:00",
        movie_id: 11,
        movie_title: "Inception",
        invitees: [@user2.id, @user3.id, 55],
        user_id: @user.id
      }  

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/viewing_parties", headers: headers, params: JSON.generate(viewing_party_params)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful

      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq(viewing_party_params[:name])
      expect(json[:data][:attributes]).to have_key(:start_time)
      expect(json[:data][:attributes][:start_time]).to include("2025-02-01")
      expect(json[:data][:attributes]).to have_key(:end_time)
      expect(json[:data][:attributes][:end_time]).to include("10:00:00")
      expect(json[:data][:attributes]).to have_key(:movie_id)
      expect(json[:data][:attributes][:movie_id]).to eq(viewing_party_params[:movie_id])
      expect(json[:data][:attributes]).to have_key(:movie_title)
      expect(json[:data][:attributes][:movie_title]).to eq(viewing_party_params[:movie_title])
    end
  end

  describe "sad paths" do
    it 'will not create a viewing party without required parameters' do
      viewing_party_params = {
        name: "",
        start_time: "",
        end_time: "",
        movie_id: nil,
        movie_title: "",
        invitees: [@user2.id, @user3.id],
        user_id: @user.id
      }

      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties", headers: headers, params: JSON.generate(viewing_party_params)

      expect(response).to have_http_status(:unprocessable_entity)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("Validation failed: Name can't be blank, Start time can't be blank, End time can't be blank, Movie can't be blank, Movie title can't be blank")
      expect(data[:status]).to eq("422")
    end

    it 'will not create a viewing party if the end time is before the start time' do
      viewing_party_params = {
        name: "test",
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 01:00:00",
        movie_id: 11,
        movie_title: "Inception",
        invitees: [@user2.id, @user3.id],
        user_id: @user.id
      }  
    
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties", headers: headers, params: JSON.generate(viewing_party_params)

      expect(response).to have_http_status(:unprocessable_entity)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("Validation failed: Start time must be before end time")
      expect(data[:status]).to eq("422")
    end

    it "will not add an invitee with an invalid id" do
      viewing_party_params = {
        name: "test",
        start_time: "2025-02-01 01:00:00",
        end_time: "2025-02-01 10:00:00",
        movie_id: 11,
        movie_title: "Inception",
        invitees: [@user2.id, @user3.id, 55],
        user_id: @user.id
      }  
    
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties", headers: headers, params: JSON.generate(viewing_party_params)

      json = JSON.parse(response.body, symbolize_names: true)
      expect(response).to be_successful
      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:attributes]).to have_key(:invitees)
      expect(json[:data][:attributes][:invitees]).to be_an(Array)
      expect(json[:data][:attributes][:invitees][0][:name]).to eq("Hank Williams")
      expect(json[:data][:attributes][:invitees][1][:name]).to eq("Baxter")
      expect(json[:data][:attributes][:invitees][2][:name]).to eq("Loki")
    end

    it "will not create a viewing party with a duration that is less than the movie runtime" do
      viewing_party_params = {
        name: "test",
        start_time: "2025-02-01 01:00:00",
        end_time: "2025-02-01 01:15:00",
        movie_id: 11,
        movie_title: "Inception",
        invitees: [@user2.id, @user3.id, 55],
        user_id: @user.id
      }  
    
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties", headers: headers, params: JSON.generate(viewing_party_params)

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:message]).to eq("Party duration is less than movie runtime!")
    end
  end
end