class Api::V1::ViewingPartiesController < ApplicationController
  
  def create
    viewing_party = ViewingParty.create!(viewing_party_params)
    render json: ViewingPartySerializer.new(viewing_party)
  end

  private

  def viewing_party_params
    params.require(:viewing_party).permit(:name, :start_time, :end_time, :movie_id, :movie_title)
  end

end