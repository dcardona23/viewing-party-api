class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |conn|
      conn.authorization :Bearer, 014da2f6be8cc33649ff1955cae1b0e1
    end

    response = conn.get("/3/movie")

    movies = JSON.parse(response.body)
  end

end