class ViewingPartySerializer
  include JSONAPI::Serializer
  attributes :name, :start_time, :end_time, :movie_id, :movie_title

  # def self.format_viewing_party(viewing_party)
  #   { data:
  #       users.map do |user|
  #         {
  #           id: user.id.to_s,
  #           type: "user",
  #           attributes: {
  #             name: user.name,
  #             username: user.username
  #           }
  #         }
  #       end
  #   }
  # end
end