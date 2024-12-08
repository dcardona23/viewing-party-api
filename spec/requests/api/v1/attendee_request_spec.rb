require "rails_helper"

RSpec.describe "Add Attendee to Viewing Party Endpoint", type: :request do
  before(:each) do
    @user = User.create!(name: "Hank Williams", username: "hkw", password: "fwefw")
    @user2 = User.create!(name: "Baxter", username: "anchorman", password: "punt")
    @user3 = User.create!(name: "Loki", username: "sonofthor", password: "godofmischief")
    
    @viewing_party = ViewingParty.create(
      name: "test", 
      start_time: "2025-02-01 01:00:00", 
      end_time: "2025-02-01 10:00:00", 
      movie_id: 11, 
      movie_title: "Inception", 
      user_id: @user.id
      )
    @viewing_party2 = ViewingParty.create(
      name: "test2", 
      start_time: "2025-02-01 10:00:00", 
      end_time: "2025-02-01 01:00:00", 
      movie_id: 11, 
      movie_title: "The Matrix", 
      user_id: @user.id)
  end

  describe "happy path" do
    it "can add an attendee to a viewing party" do
      attendee_params = { invitees_user_id: @user3.id }  
      
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties/#{@viewing_party.id}/attendees", 
          headers: headers, 
          params: JSON.generate(attendee_params)  

      expect(response).to be_successful

      json = JSON.parse(response.body, symbolize_names: true)
      expect(json[:data]).to be_a(Hash)

      expect(json[:data][:attributes]).to have_key(:invitees)
      expect(json[:data][:attributes][:invitees]).to be_a(Array)
      expect(json[:data][:attributes][:invitees][0]).to have_key(:id)
      expect(json[:data][:attributes][:invitees][0][:id]).to eq(@user3.id)
    end
  end

  describe "sad paths" do
    it "will not add an attendee to a viewing party if the attendee is already invited" do
      viewing_party = ViewingParty.create(
        name: "test2", 
        start_time: "2025-02-01 01:00:00", 
        end_time: "2025-02-01 10:00:00", 
        movie_id: 7, 
        movie_title: "The Matrix", 
        invitees: [@user3], 
        user_id: @user.id
        )
      attendee_params = { invitees_user_id: @user3.id }  
      
      headers = { "CONTENT_TYPE" => "application/json" }
      post "/api/v1/viewing_parties/#{viewing_party.id}/attendees", 
          headers: headers, 
          params: JSON.generate(attendee_params)  

          data = JSON.parse(response.body, symbolize_names: true)
          # binding.pry
          expect(response).to have_http_status(:unprocessable_entity)

          expect(data[:message]).to eq("User is already an invitee")
          expect(data[:status]).to eq("422")
    end

    it "will return an error if an attendee has an invalid user id" do
      
    end
  end
end
