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
    describe "happy path" do
      it "can retrieve a movie by id", :vcr do 
        movie_id = 75780
        get "/api/v1/movies/#{movie_id}"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)
      end

      it "can retrieve full movie information by id", :vcr do
        movie_id = 75780
        get "/api/v1/movies/#{movie_id}?data=full"

        expect(response).to be_successful
        json = JSON.parse(response.body, symbolize_names: true)

        expect(json[:data][:id]).to be_a(String)
        expect(json[:data][:type]).to eq("movie")
        expect(json[:data][:attributes]).to have_key(:title)
        expect(json[:data][:attributes]).to have_key(:vote_average)
        expect(json[:data][:attributes]).to have_key(:release_year)
        expect(json[:data][:attributes]).to have_key(:vote_average)
        expect(json[:data][:attributes]).to have_key(:runtime)
        expect(json[:data][:attributes]).to have_key(:genres)
        expect(json[:data][:attributes][:genres]).to be_an(Array)
        expect(json[:data][:attributes]).to have_key(:summary)
        expect(json[:data][:attributes]).to have_key(:cast)
        expect(json[:data][:attributes][:cast]).to be_an(Array)
        expect(json[:data][:attributes]).to have_key(:total_reviews)
        expect(json[:data][:attributes]).to have_key(:reviews)
        expect(json[:data][:attributes][:reviews]).to be_an(Array)
      end
    end

    describe "sad paths" do
      it "returns an error if a movie does not exist with the specified id", :vcr do
        movie_id = 1
        get "/api/v1/movies/#{movie_id}"

      expect(response).to have_http_status(:not_found)
      data = JSON.parse(response.body, symbolize_names: true)

      expect(data[:message]).to eq("Movie with Id 1 not found")
      expect(data[:status]).to eq("404")
      end    
    end
  end
end