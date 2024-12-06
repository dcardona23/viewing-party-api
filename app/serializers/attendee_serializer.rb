class AttendeeSerializer
  include JSONAPI::Serializer
  attributes :name, :username

  def self.format_attendee(attendee)
    { data:
          {
            id: attendee.id.to_s,
            type: "invitee",
            attributes: {
              name: attendee.name,
              username: attendee.username
            }
          }
    }
  end
end