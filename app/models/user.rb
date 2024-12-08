class User < ApplicationRecord
  has_many :attendees
  has_many :viewing_parties, through: :attendees

  validates :name, presence: true
  validates :username, presence: true, uniqueness: true
  validates :password, presence: { require: true }

  has_secure_password
  has_secure_token :api_key

  def get_attributes
    viewing_parties_hosted = ViewingParty.where(user_id: self.id)
    viewing_parties_invited = ViewingParty.joins(:attendees).where(attendees: { user_id: self.id })

    user_data = {
      id: self.id,
      type: "user",
      attributes: {
        name: self.name,
        username: self.username,
        viewing_parties_hosted: viewing_parties_hosted.map { |viewing_party_hosted|
          {
            id: viewing_party_hosted.id,
            name: viewing_party_hosted.name,
            start_time: viewing_party_hosted.start_time,
            end_time: viewing_party_hosted.end_time,
            movie_id: viewing_party_hosted.movie_id,
            movie_title: viewing_party_hosted.movie_title,
            host_id: self.id
          }
        },
        viewing_parties_invited: viewing_parties_invited.map { |viewing_party_invited|
          {
            name: viewing_party_invited.name,
            start_time: viewing_party_invited.start_time,
            end_time: viewing_party_invited.end_time,
            movie_id: viewing_party_invited.movie_id,
            movie_title: viewing_party_invited.movie_title,
            host_id: viewing_party_invited.user_id
          }
        }
      }
    }
    user_data
    # binding.pry
  end
end