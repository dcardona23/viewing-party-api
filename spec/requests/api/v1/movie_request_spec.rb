require "rails_helper"

RSpec.describe "Movies By Search Params Endpoint" do
  describe "happy path" do
    it "can retrieve movies that match search params", :vcr do 

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

    describe "sad path" do
    
  end

  describe "Top Rated Movies Endpoint" do
    it "can retrieve the highest rated movies", :vcr do 

      get "/api/v1/movies?sort_by_rating=desc"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)

      rating_one = json[:data][0][:attributes][:vote_average]
      rating_two = json[:data][1][:attributes][:vote_average]
      rating_twenty = json[:data][19][:attributes][:vote_average]

      expect(json[:data][0][:id]).to be_a(String)
      expect(json[:data].length).to eq(20)
      expect(json[:data][0][:type]).to eq("movie")
      expect(json[:data][0][:attributes]).to have_key(:title)
      expect(json[:data][0][:attributes]).to have_key(:vote_average)
      expect(rating_one >= rating_two)
      expect(rating_one >= rating_twenty)
    end
  end

  describe "Movie by ID Endpoint" do
    it "can retrieve a movie by id", :vcr do 
      movie_id = 75780
      get "/api/v1/movies/#{movie_id}"

      expect(response).to be_successful
      json = JSON.parse(response.body, symbolize_names: true)
    end
  end
end