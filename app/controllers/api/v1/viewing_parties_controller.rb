class Api::V1::ViewingPartiesController < ApplicationController
rescue_from StandardError, with: :handle_runtime_error

  def create
    host = User.find(params[:user_id])
    viewing_party = ViewingParty.create!(viewing_party_params)

    validate_runtime(viewing_party, MovieGateway.get_movie_runtime_raw(params[:movie_id]))
    
    Attendee.create!(viewing_party: viewing_party, user: host, is_host: true, name: host.name, username: host.username)

    viewing_party.add_invitees(params[:invitees])

    render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :user_id)
  end

  def validate_runtime(viewing_party, runtime)
    start_time = DateTime.parse(viewing_party.start_time) 
    end_time = DateTime.parse(viewing_party.end_time) 

    party_duration_in_minutes = ((end_time - start_time) * 24 * 60 * 60 / 60).to_i

    raise StandardError, "Party duration is less than movie runtime!" if party_duration_in_minutes < runtime
  end

  def handle_runtime_error(exception)
    render json: ErrorSerializer.format_unprocessable(exception.message, "422"), status: :unprocessable_entity
  end
end