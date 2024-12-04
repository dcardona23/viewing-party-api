class Api::V1::ViewingPartiesController < ApplicationController
  
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

end