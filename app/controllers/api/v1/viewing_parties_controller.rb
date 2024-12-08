class Api::V1::ViewingPartiesController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  def create
    host = User.find(params[:user_id])
    invitees = params[:invitees]

    viewing_party = ViewingParty.create!(viewing_party_params)
    runtime = MovieGateway.get_movie_runtime(params[:movie_id])

    if viewing_party.validate_runtime(runtime)
        Attendee.create!(viewing_party: viewing_party, user: host, is_host: true, name: host.name, username: host.username)

        viewing_party.add_invitees(invitees)
        render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
    else
      error_message = "Party duration is less than movie runtime!"
      render json: ErrorSerializer.format_unprocessable(error_message, "422")
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :user_id)

  end

  def record_invalid(exception)
    render json: { message: "Your query could not be completed", errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
end