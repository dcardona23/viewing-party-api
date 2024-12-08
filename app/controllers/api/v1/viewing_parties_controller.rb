class Api::V1::ViewingPartiesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
rescue_from ActionController::ParameterMissing, with: :parameter_missing

  def create
    host = User.find(params[:user_id])
    invitees = params[:invitees]

    runtime = MovieGateway.get_movie_runtime(params[:movie_id])

    viewing_party = ViewingParty.create!(viewing_party_params) 
    Attendee.create!(viewing_party: viewing_party, user: host, is_host: true, name: host.name, username: host.username)

    viewing_party.add_invitees(invitees)
    render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :user_id)

  end

  def record_not_found(exception)
    render json: { message: "Your query could not be completed", errors: exception.message }, status: :not_found
  end

  def record_invalid(exception)
    render json: { message: "Your query could not be completed", errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end

  def parameter_missing(exception)
    render json: ErrorSerializer.format_error(exception), status: :bad_request
  end
end