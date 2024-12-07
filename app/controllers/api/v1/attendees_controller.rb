class Api::V1::AttendeesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
rescue_from ActionController::ParameterMissing, with: :parameter_missing
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

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

  def parameter_missing(exception)
    render json: ErrorSerializer.new(exception.message, "400"), status: :bad_request
  end

  def record_not_found(exception)
    render json: ErrorSerializer.new(exception.message, "404"), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.new(exception.message, "422"), status: :unprocessable_entity
  end
end