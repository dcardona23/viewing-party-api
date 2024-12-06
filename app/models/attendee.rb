class Attendee < ApplicationRecord
  belongs_to :viewing_party
  belongs_to :user

  validates :user_id, uniqueness: { scope: :viewing_party_id, message: "is already an invitee" }
end