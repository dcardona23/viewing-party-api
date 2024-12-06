class ViewingParty < ApplicationRecord
  belongs_to :movie
  has_many :attendees
  has_many :users, through: :attendees

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

end