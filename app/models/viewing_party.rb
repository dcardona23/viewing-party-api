class ViewingParty < ApplicationRecord
  belongs_to :user
  has_many :attendees
  has_many :invitees, through: :attendees, source: :user

  validates :name, :start_time, :end_time, :movie_id, :movie_title, :user_id, presence: true
  before_validation :parse_times
  validate :start_time_before_end_time

  private

  def parse_times
    self.start_time = DateTime.parse(start_time) if start_time.present?
    self.end_time = DateTime.parse(end_time) if end_time.present?
  end

  def start_time_before_end_time
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:start_time, "must be before end time")
    elsif start_time.nil? && end_time.nil?
      errors.add(:base, "Both start time and end time must be present")
    end
  end
end