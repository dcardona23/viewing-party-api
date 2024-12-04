require "rails_helper"

RSpec.describe "Movies Sorted by Rating Endpoint" do
  describe "happy path" do
    it "can retrieve the highest rated movies", :vcr do 

      get "/api/v1/movies?query=Jack Reacher"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
      
      expect(json[:data][0][:id]).to be_a(String)
      expect(json[:data][0][:type]).to eq("movie")
      expect(json[:data][0][:attributes]).to have_key(:title)
      expect(json[:data][0][:attributes]).to have_key(:vote_average)
      expect(json[:data][0][:attributes][:title]).to eq("Jack Reacher")
    end
  end
end