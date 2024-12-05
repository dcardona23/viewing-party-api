require "rails_helper"

RSpec.describe ViewingParty do

  describe "relationships" do
    it {should belong_to(:host)}
  end
  
  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:start_time)}
    it {should validate_presence_of(:end_time)}
    it {should validate_presence_of(:movie_id)}
    it {should validate_presence_of(:movie_title)}
    it {should validate_presence_of(:host_id)}
    it {should validate_presence_of(:invitees)}

    it "validates host is valid user" do 
      user = User.create!(name: "test", username: "test", password: "test")
      viewing_party = ViewingParty.new(name: "test", host_id: user.id, start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test", invitees: [1])

      user1 = User.create!(name: "test2", username: "test2", password: "test2")
      invalid_viewing_party = ViewingParty.new(name: "test2", host_id: 99999, start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test", invitees: [1])

      expect(viewing_party.valid?).to be(true)
      expect(viewing_party.host).to eq(user)
      expect(invalid_viewing_party.valid?).to be(false)
      expect(invalid_viewing_party.host).to eq(nil)
    end

    it "validates movie is valid movie", :vcr do
      user = User.create!(name: "test", username: "test", password: "test")
      viewing_party = ViewingParty.new(name: "test", host_id: user.id, start_time: "10:00", end_time: "12:00", movie_id: 75780, movie_title: "test", invitees: [1])
      viewing_party2 = ViewingParty.new(name: "test", host_id: user.id, start_time: "10:00", end_time: "12:00", movie_id: 1, movie_title: "test", invitees: [1])

      expect(viewing_party.valid?).to be(true)
      expect(viewing_party2.valid?).to be(false)
    end
  end  

  before(:each) do
    @user1 = User.create!(name: "bob", username: "bob", password: "bob")
    @user2 = User.create!(name: "sara", username: "sara", password: "sara")
    @user3 = User.create!(name: "mike", username: "mike", password: "mike")

    @viewing_party2 = ViewingParty.new(name: "test2", host_id: 99999, start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test", invitees: [1])
  end

  describe "Create Viewing Party Endpoint" do
    describe "happy path" do
      it "can save a valid viewing party", :vcr do 
        viewing_party = ViewingParty.new(name: "test", host_id: @user1.id, start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test", invitees: [1])

        expect(viewing_party.save).to be(true)
      end
    end

    describe "sad path" do
      it "cannot save a viewing party that is missing required attributes" do
        invalid_viewing_party = ViewingParty.new(name: "test", host_id: 9999, start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test", invitees: [1])

        invalid_viewing_party2 = ViewingParty.new(name: "", host_id: 9999, start_time: "", end_time: "12:00", movie_id: 3, movie_title: "test", invitees: [1])

        invalid_viewing_party3 = ViewingParty.new(name: "test", host_id: 9999, start_time: "10:00", end_time: "", movie_id: 3, movie_title: "test", invitees: [1])

        invalid_viewing_party4 = ViewingParty.new(name: "test", host_id: 9999, start_time: "10:00", end_time: "12:00", movie_id: nil, movie_title: "test", invitees: [1])

        invalid_viewing_party5 = ViewingParty.new(name: "test", host_id: 9999, start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "", invitees: [1])

        expect(invalid_viewing_party.save).to be(false)
        expect(invalid_viewing_party2.save).to be(false)
        expect(invalid_viewing_party3.save).to be(false)
        expect(invalid_viewing_party4.save).to be(false)
        expect(invalid_viewing_party5.save).to be(false)
      end
    end
  end
end