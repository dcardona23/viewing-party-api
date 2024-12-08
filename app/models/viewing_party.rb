class ViewingParty < ApplicationRecord
  belongs_to :user
  has_many :attendees
  has_many :invitees, through: :attendees, source: :user

  validates :name, :start_time, :end_time, :movie_id, :movie_title, :user_id, presence: true
  before_validation :parse_times
  validate :start_time_before_end_time

  def add_invitees(invitees)
    if invitees.present?
      invitees.each do |invitee_id|
        invitee = User.find_by(id: invitee_id)
        if invitee
          Attendee.create!(viewing_party: self, user: invitee, is_host: false, name: invitee.name, username: invitee.username) 
        else
        Rails.logger.info("Skipping invalid invitee Id: #{invitee_id}")
        end
      end
    end
  end

  def validate_runtime(runtime)
    start_time = DateTime.parse(self.start_time) 
    end_time = DateTime.parse(self.end_time) 

    party_duration_in_seconds = (end_time - start_time) * 24 * 60 * 60
    party_duration_in_minutes = (party_duration_in_seconds / 60).to_i

    true unless party_duration_in_minutes < runtime
  end

  private

  def parse_times
    start_time = DateTime.parse(self.start_time) if start_time.present?
    end_time = DateTime.parse(self.end_time) if end_time.present?
  end

  def start_time_before_end_time
    if start_time.present? && end_time.present? && start_time >= end_time
      errors.add(:start_time, "must be before end time")
    elsif start_time.nil? && end_time.nil?
      errors.add(:base, "Both start time and end time must be present")
    end
  end
end