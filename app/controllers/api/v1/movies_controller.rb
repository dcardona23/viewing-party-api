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
    if params[:data]
      movie_full = MovieGateway.get_movie_by_id_full(params[:id])
    else
      movie = MovieGateway.get_movie_by_id(params[:id])
    end

    if params[:data]
      render json: MovieSerializer.format_movie_full(movie_full)
    else
      render json: MovieSerializer.format_movie(movie)
    end
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :vote_average, :query, :sort_by_rating)
  end
end