class Api::V1::MoviesController < ApplicationController
  def index
      if params[:query].present?
        movies = MovieGateway.get_movies_by_search_param(params[:query])
      elsif params[:sort_by_rating].present?
        movies = MovieGateway.get_movies_sorted_by_rating
      else
        movies = []
      end

    render json: MovieSerializer.format_movies(movies)
  end

  def show
    id = params[:id]
    movie = MovieGateway.get_movie_by_id(id)

    render json: MovieSerializer.format_movie(movie)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :vote_average, :query, :sort_by_rating)
  end
end