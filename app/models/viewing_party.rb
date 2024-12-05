class ViewingParty < ApplicationRecord
  has_many :movies

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

  before_validation :check_movie_id

  def check_movie_id
    return unless movie_id.present?

    if !movie_is_valid_movie
      errors.add(:movie_id, "is not a valid movie")
    end
  end

  def movie_is_valid_movie
    movie = MovieGateway.get_movie_by_id(movie_id)
    # binding.pry
    !movie.nil?
  end
end