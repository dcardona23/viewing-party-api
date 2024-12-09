class UserSerializer
  include JSONAPI::Serializer
  attributes :name, :username, :api_key

  def self.format_user_list(users)
    { data:
        users.map do |user|
          {
            id: user.id.to_s,
            type: "user",
            attributes: {
              name: user.name,
              username: user.username
            }
          }
        end
    }
  end

  def self.format_user(user)
    { data:
          {
            id: user[:id],
            type: "user",
            attributes: {
              name: user[:attributes][:name],
              username: user[:attributes][:username],
              viewing_parties_hosted: user[:attributes][:viewing_parties_hosted],
              viewing_parties_invited: user[:attributes][:viewing_parties_invited]
            }
          }
        }
  end
end