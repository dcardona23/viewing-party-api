class Api::V1::ViewingPartiesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid


  def create
    host = User.find(params[:user_id])

    viewing_party = ViewingParty.new(viewing_party_params)

    if viewing_party.save
      attendee = Attendee.create!(viewing_party: viewing_party, user: host, is_host: true, name: host.name, username: host.username)
      render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
    else
      render json: {error: "Failed to create viewing party", details: viewing_party.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id, invitees: [])
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end

  def record_invalid(exception)
    render json: ErrorSerializer.format_error(exception), status: :unprocessable_entity
  end

end