class Api::V1::AttendeesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def create
    viewing_party = ViewingParty.find(params[:id])
    user = User.find(params[:invitees_user_id])

    if viewing_party.invitees.include?(user)
      render json: { error: "User is already an invitee" }, status: :unprocessable_entity
    else
      if user && viewing_party
        viewing_party.invitees << user 
        render json: ViewingPartySerializer.format_viewing_party(viewing_party)
      else
        render json: { error: "User or Viewing Party not found" }, status: :not_found
      end
    end
  end

  private

  def attendee_params
    params.require(:attendee).permit(:viewing_party_id, :user_id, :is_host, :name, :username)
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(exception.record.errors.full_messages).serializable_hash, status: :unprocessable_entity
  end
end