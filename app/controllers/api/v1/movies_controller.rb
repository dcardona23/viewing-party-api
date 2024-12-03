class Api::V1::MoviesController < ApplicationController
  def index
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
    end

    response = conn.get("/3/search/movie?query=Jack+Reacher")
    # movies = Movie.filter_movies(Movie.all, params)
    json = JSON.parse(response.body, symbolize_names: true)

    formatted_json = { data:
    json[:results].map do |movie|
      {
        id: movie[:id.to_s],
        type: "movie",
        attributes: {
          title: movie[:title],
          vote_average: movie[:vote_average]
        }
      }
    end
}
    render json: { data: formatted_json }
  end
end