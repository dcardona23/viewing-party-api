require "rails_helper"

RSpec.describe "Create Viewing Party Endpoint", type: :request do
  describe "happy path" do
    it "can create a viewing party" do
      user = User.create!(name: "Hank Williams", username: "hkw", password: "fwefw")


      viewing_party_params = {
        name: "test",
        start_time: "12",
        end_time: "2",
        movie_id: 4,
        movie_title: "Inception"
      }

      headers = {"CONTENT_TYPE" => "application/json"}
      post "/api/v1/viewing_parties/#{user.id}", headers: headers, params: JSON.generate(viewing_party: viewing_party_params)

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
end