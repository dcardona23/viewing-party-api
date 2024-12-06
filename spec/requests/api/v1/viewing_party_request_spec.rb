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
        start_time: "2025-02-01 10:00:00",
        end_time: "2025-02-01 01:00:00",
        movie_id: 4,
        movie_title: "Inception",
        invitees: [@user2.id, @user3.id]
      }  
     
      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/viewing_parties/#{@user.id}", headers: headers, params: JSON.generate(viewing_party: viewing_party_params)

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data]).to be_a(Hash)
      expect(json[:data][:attributes]).to have_key(:name)
      expect(json[:data][:attributes][:name]).to eq("test")
      expect(json[:data][:attributes]).to have_key(:start_time)
      expect(json[:data][:attributes][:start_time]).to eq("12")
      expect(json[:data][:attributes]).to have_key(:end_time)
      expect(json[:data][:attributes][:end_time]).to eq("2")
      expect(json[:data][:attributes]).to have_key(:movie_id)
      expect(json[:data][:attributes][:movie_id]).to eq(4)
      expect(json[:data][:attributes]).to have_key(:movie_title)
      expect(json[:data][:attributes][:movie_title]).to eq("Inception")
    end
  end

  describe "sad path" do
    it 'will not create a viewing party without required parameters' do
      viewing_party_params = {
        name: "",
        start_time: "",
        end_time: "",
        movie_id: nil,
        movie_title: "",
        invitees: [@user2.id, @user3.id]
      }

      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties/#{@user.id}", headers: headers, params: JSON.generate(viewing_party_params)

      expect(response).to have_http_status(:unprocessable_entity)

      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("Your query could not be completed")
      expect(data[:errors]).to be_an(Array)
      expect(data[:errors][0]).to eq("Name can't be blank")
      expect(data[:errors][1]).to eq("Start time can't be blank")
      expect(data[:errors][2]).to eq("End time can't be blank")
      expect(data[:errors][3]).to eq("Movie can't be blank")
      expect(data[:errors][4]).to eq("Movie title can't be blank")
    end
  end

end