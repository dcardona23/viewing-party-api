class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: "User"
  has_many :movies

  validates :name, :host_id, :start_time, :end_time, :movie_id, :movie_title, presence: true
  validate :host_is_valid_user
  validate :movie_is_valid_movie

  def host_is_valid_user
    User.exists?(id: host_id)
  end

  def movie_is_valid_movie
    
  end

end