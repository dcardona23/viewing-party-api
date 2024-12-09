require 'rails_helper'

RSpec.describe MovieGateway do
  describe "getting movies by search params" do
    it "gets movies by search params", :vcr do
      movies = MovieGateway.get_movies_by_search_param("Anchorman: The Legend of Ron Burgundy")

      expect(movies).to be_an(Array)
      expect(movies.length).to be > 0
      expect(movies.first).to be_a(Movie)
      expect(movies.first.title).to eq("Anchorman: The Legend of Ron Burgundy")
    end
  end

  describe "getting movies sorted by rating" do
    it "gets movies sorted by rating", :vcr do
      movies = MovieGateway.get_movies_sorted_by_rating

      expect(movies).to be_an(Array)
      expect(movies.length).to eq(20)
      expect(movies.first).to be_a(Movie)
      expect(movies.first.vote_average).to eq(10)
    end
  end

  describe "getting movies by id" do
    it "gets a movie by its id", :vcr do
      movie = MovieGateway.get_movie_by_id(11)

      expect(movie.id).to eq(11)
      expect(movie.title).to eq("Star Wars")
      expect(movie.vote_average).to eq(8.203)
    end

    it "return an error if a movie id is invalid", :vcr do
      expect { MovieGateway.get_movie_by_id(1) }.to raise_error(MovieNotFoundError)
    end
  end

  describe "getting a movie runtime" do
    it "gets a movies runtime by its id", :vcr do
      runtime = MovieGateway.get_movie_runtime_raw(11)

      expect(runtime).to be_an(Integer)
      expect(runtime).to eq(121)
    end
  end

  describe "getting movie details" do
    it "gets a movies full details by its id", :vcr do
      movie = MovieGateway.get_movie_by_id_full(11)

      expect(movie).to have_key(:id)
      expect(movie).to have_key(:title)
      expect(movie).to have_key(:release_year)
      expect(movie).to have_key(:vote_average)
      expect(movie).to have_key(:runtime)
      expect(movie).to have_key(:genres)
      expect(movie[:genres]).to be_an(Array)
      expect(movie[:genres][0]).to eq("Adventure")
      expect(movie).to have_key(:summary)
      expect(movie).to have_key(:cast)
      expect(movie[:cast]).to be_an(Array)
      expect(movie[:cast][0]).to have_key(:character)
      expect(movie[:cast][0]).to have_key(:actor)
      expect(movie[:cast][0][:character]).to eq("Luke Skywalker")
      expect(movie[:cast][0][:actor]).to eq("Mark Hamill")
      expect(movie).to have_key(:total_reviews)
      expect(movie[:total_reviews]).to eq(6)
      expect(movie).to have_key(:reviews)
      expect(movie[:reviews]).to be_an(Array)
      expect(movie[:reviews][0]).to have_key(:author)
      expect(movie[:reviews][0][:author]).to eq("Cat Ellington")
      expect(movie[:reviews][0]).to have_key(:review)
    end
  end
end