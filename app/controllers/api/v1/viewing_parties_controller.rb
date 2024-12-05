class Api::V1::ViewingPartiesController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :record_not_found


  def create
    viewing_party = ViewingParty.new(viewing_party_params)

    if viewing_party.save
      render json: ViewingPartySerializer.format_viewing_party(viewing_party) 
    end
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title, :host_id)
  end

  def record_not_found(exception)
    render json: ErrorSerializer.format_error(exception), status: :not_found
  end

end