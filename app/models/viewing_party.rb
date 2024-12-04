class ViewingParty < ApplicationRecord
  belongs_to :host, class_name: "User"

  validates :name, :host_id, :start_time, :end_time, :movie_id, :movie_title, presence: true
  validate :host_is_valid_user

  def host_is_valid_user
    User.exists?(id: host_id)
  end

end