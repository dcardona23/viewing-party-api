class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: "User"

  validates :name, :start_time, :end_time, :movie_id, :movie_title, presence: true
end