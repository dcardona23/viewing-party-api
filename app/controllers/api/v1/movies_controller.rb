class Api::V1::MoviesController < ApplicationController
  def index
    movies = Movie.all

    conn = Faraday.new(url: "https://api.themoviedb.org/3")

    response = conn.get("/search/movie")
  end

end