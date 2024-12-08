require "rails_helper"

RSpec.describe User, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:password) }
    it { should have_secure_password }
    it { should have_secure_token(:api_key) }
  end

  before(:each) do
    @user = User.create!(name: "bob", username: "bob", password: "bob")
    @user2 = User.create!(name: "sara", username: "sara", password: "sara")
    @user3 = User.create!(name: "mike", username: "mike", password: "mike")
    
    @viewing_party = ViewingParty.create!(
        name: "test", 
        start_time: "2025-02-01 01:00:00", 
        end_time: "2025-02-01 10:00:00", 
        movie_id: 75780, 
        movie_title: "test", 
        user_id: @user3.id
        )

    @viewing_party2 = ViewingParty.create!(
      name: "test2", 
      start_time: "10:00", 
      end_time: "12:00", 
      movie_id: 3, 
      movie_title: "test", 
      user_id: @user.id
      )   

    Attendee.create!(
      viewing_party: @viewing_party2, user: @user3, is_host: false, 
    )
  end
  describe "getting user information" do
    it "gets viewing parties a user has hosted" do
      user_attributes = @user3.get_attributes

      expect(user_attributes).to be_a(Hash)
      expect(user_attributes).to have_key(:id)
      expect(user_attributes).to have_key(:type)
      expect(user_attributes).to have_key(:attributes)
      expect(user_attributes[:attributes]).to have_key(:name)
      expect(user_attributes[:attributes]).to have_key(:username)
      expect(user_attributes[:attributes]).to have_key(:viewing_parties_hosted)
      expect(user_attributes[:attributes]).to have_key(:viewing_parties_invited)

      expect(user_attributes[:attributes][:viewing_parties_hosted]).to be_an(Array)
      expect(user_attributes[:attributes][:viewing_parties_invited]).to be_an(Array)
      expect(user_attributes[:attributes][:viewing_parties_hosted][0][:name]).to eq("test")
      expect(user_attributes[:attributes][:viewing_parties_hosted].length).to eq(1)
    end
  end
end