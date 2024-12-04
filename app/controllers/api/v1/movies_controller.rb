class Api::V1::MoviesController < ApplicationController
  def index
      movies = MovieGateway.get_movies_by_search_param(params[:query]) if params[:query].present?
      movies = MovieGateway.get_movies_sorted_by_rating(params[:query]) if params[:sort_by_rating].present?

    render json: MovieSerializer.format_movies(movies)
  end

  private

  def movie_params
    params.require(:movie).permit(:title, :vote_average, :query, :sort_by_rating)
  end

end