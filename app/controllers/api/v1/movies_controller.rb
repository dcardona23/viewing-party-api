require './app/errors/movie_not_found_error'

class Api::V1::MoviesController < ApplicationController
  rescue_from MovieNotFoundError, with: :movie_not_found

  def index
      if params[:query].present?
        movies = MovieGateway.get_movies_by_search_param(params[:query])
      else params[:sort_by_rating].present?
        movies = MovieGateway.get_movies_sorted_by_rating
      end

    render json: MovieSerializer.format_movies(movies)
  end

  def show
    if params[:data]
      movie_full = MovieGateway.get_movie_by_id_full(params[:id])
      render json: MovieSerializer.format_movie_full(movie_full)
    else
      movie = MovieGateway.get_movie_by_id(params[:id])
      render json: MovieSerializer.format_movie(movie)
    end
    rescue MovieNotFoundError => e
      render json: { message: e.message, status: "404" }, status: :not_found
    end

  private

  def movie_params
    params.require(:movie).permit(:title, :vote_average, :query, :sort_by_rating)
  end

  def movie_not_found(exception)
    render json: { message: "Movie not found", errors: [exception.message] }, status: :not_found
  end
end