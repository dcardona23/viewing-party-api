require "rails_helper"

RSpec.describe ViewingParty do

  describe "validations" do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:start_time)}
    it {should validate_presence_of(:end_time)}
    it {should validate_presence_of(:movie_id)}
    it {should validate_presence_of(:movie_title)}

    it "validates start time is before end time", :vcr do
      user = User.create!(name: "test", username: "test", password: "test")
      viewing_party = ViewingParty.create(name: "test", start_time: "2025-02-01 10:00:00", end_time: "2025-02-01 01:00:00", movie_id: 75780, movie_title: "test")

      expect(viewing_party.valid?).to be(false)
    end
  end  

  before(:each) do
    @user1 = User.create!(name: "bob", username: "bob", password: "bob")
    @user2 = User.create!(name: "sara", username: "sara", password: "sara")
    @user3 = User.create!(name: "mike", username: "mike", password: "mike")

    @viewing_party2 = ViewingParty.new(name: "test2", start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test")
  end

  describe "Create Viewing Party Endpoint" do
    describe "happy path" do
      it "can save a valid viewing party", :vcr do 
        viewing_party = ViewingParty.new(name: "test", start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test")

        expect(viewing_party.save).to be(true)
      end
    end

    describe "sad path" do
      it "cannot save a viewing party that is missing required attributes" do
        viewing_party = ViewingParty.new(name: "test", start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "test")

        invalid_viewing_party2 = ViewingParty.new(name: "", start_time: "", end_time: "12:00", movie_id: 3, movie_title: "test")

        invalid_viewing_party3 = ViewingParty.new(name: "test", start_time: "10:00", end_time: "", movie_id: 3, movie_title: "test")

        invalid_viewing_party4 = ViewingParty.new(name: "test", start_time: "10:00", end_time: "12:00", movie_id: nil, movie_title: "test")

        invalid_viewing_party5 = ViewingParty.new(name: "test", start_time: "10:00", end_time: "12:00", movie_id: 3, movie_title: "")

        expect(viewing_party.save).to be(true)
        expect(invalid_viewing_party2.save).to be(false)
        expect(invalid_viewing_party3.save).to be(false)
        expect(invalid_viewing_party4.save).to be(false)
        expect(invalid_viewing_party5.save).to be(false)
      end
    end
  end
end