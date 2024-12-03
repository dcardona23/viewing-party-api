require "rails_helper"

RSpec.describe "Movies Sorted by Rating Endpoint" do
  describe "happy path" do
    it "can retrieve the highest rated movies", :vcr do 

      get "/api/v1/movies"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:data][:id]).to be_nil
      expect(json[:data][:type]).to eq("movie")
    end
  end
end