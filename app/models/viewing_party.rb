class ViewingParty < ApplicationRecord
  has_many :attendees
  has_many :invitees, through: :attendees, source: :user

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true

end