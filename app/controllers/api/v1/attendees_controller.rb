class Api::V1::AttendeesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def create
    viewing_party = ViewingParty.find(params[:id])
    user = User.find(params[:invitees_user_id])

    viewing_party.invitees << user 
    
    render json: ViewingPartySerializer.format_viewing_party(viewing_party)
  end

  private

  def record_not_found(exception)
    render json: ErrorSerializer.format_not_found(exception), status: :not_found
  end
end