class Api::V1::ViewingPartiesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid


  def create
    host = User.find(params[:user_id])

    if host.nil?
      raise ActiveRecord::RecordInvalid, "Unauthorized" 
    else
      viewing_party = ViewingParty.new(viewing_party_params)
    end

    render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
    attendee = Attendee.create!(viewing_party_id: viewing_party.id, user_id: host.id, is_host: true, name: host.name, username: host.username)
    binding.pry
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id, invitees: [])
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end

end