class Api::V1::AttendeesController < ApplicationController

  def create
    viewing_party = ViewingParty.find(params[:id])
    user = User.find(params[:invitees_user_id])

    if viewing_party.invitees.include?(user)
      error_message = "User is already an invitee"
      render json: ErrorSerializer.format_unprocessable(error_message, "422"), status: :unprocessable_entity
    else
      viewing_party.invitees << user 
      render json: ViewingPartySerializer.format_viewing_party(viewing_party)
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit(:viewing_party_id, :user_id, :is_host, :name, :username)
  end
end