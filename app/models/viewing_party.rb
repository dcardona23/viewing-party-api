class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: "User"
  has_many :movies

  validates :name, :host_id, :start_time, :end_time, :movie_id, :movie_title, :invitees, presence: true
  validate :host_is_valid_user

  before_validation :check_movie_id

  def host_is_valid_user
    unless User.exists?(id: host_id)
      errors.add(:host_id, "invalid host id")
    end
  end

  def check_movie_id
    return unless movie_id.present?

    if !movie_is_valid_movie
      errors.add(:movie_id, "is not a valid movie")
    end
  end

  def movie_is_valid_movie
    movie = MovieGateway.get_movie_by_id(movie_id)
    movie[:success] != false
  end
end