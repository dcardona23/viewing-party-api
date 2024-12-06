class Api::V1::ViewingPartiesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid


  def create
    host = User.find(params[:user_id])
    invitees = params[:viewing_party].delete(:invitees)

    viewing_party_params = params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)

    viewing_party = ViewingParty.create!(viewing_party_params)

    if viewing_party.save
      Attendee.create!(viewing_party: viewing_party, user: host, is_host: true, name: host.name, username: host.username)

      if invitees
        invitees.each do |invitee_id|
          invitee = User.find(invitee_id)
          Attendee.create!(viewing_party: viewing_party, user: invitee, is_host: false, name: invitee.name, username: invitee.username)
        end
      end

      render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
      
    else
      render json: {error: "Failed to create viewing party", details: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def record_not_found(exception)
    render json: { message: "Your query could not be completed", errors: exception.message }, status: :not_found
  end

  def record_invalid(exception)
    render json: { message: "Your query could not be completed", errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end