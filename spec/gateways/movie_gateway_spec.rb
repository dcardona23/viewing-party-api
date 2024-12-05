require 'rails_helper'

RSpec.describe MovieGateway do
  describe "get images for an artist" do
    it "calls Unsplash API with artist query and returns json response" do
      response_array = MovieGateway.get_movies_by_search_param("Jack Reacher")
# binding.pry
      expect(response_array).to be_a(Array)

      first_response = response_array[0]
      expect(first_response).to have_key(:id)
      expect(first_response).to have_key(:title)
      expect(first_response).to have_key(:overview)
    end
  end
end