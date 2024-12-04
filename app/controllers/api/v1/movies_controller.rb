class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
    end

    response = conn.get("/3/search/movie?query=#{params[:query]}") if params[:query]
    json = JSON.parse(response.body, symbolize_names: true)

    movies = json[:results] || []
    render json: MovieSerializer.format_movies(movies)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :vote_average, :query, :sort_by_rating)
  end

end