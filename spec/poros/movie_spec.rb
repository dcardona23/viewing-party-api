require "rails_helper"

RSpec.describe Movie do
  let(:movie_json) do
    {
      id: 1,
      title: "Inception",
      vote_average: 8.8,
      runtime: 148,
      overview: "A mind-bending thriller",
      cast: [ 
        {
          character: "Jack",
          actor: "Leonardo DiCaprio"
        }
      ],
      total_reviews: 5,
      reviews: [
        {
          author: "Jane",
          review: "Great movie"
        }
      ]
    }
  end

  describe "initialize" do 
    it "sets data correctly when full details is false" do
      movie = Movie.new(movie_json)

      expect(movie.id).to eq(1)
      expect(movie.title).to eq("Inception")
      expect(movie.vote_average).to eq(8.8)
      expect(movie.runtime).to be(nil)
      expect(movie.summary).to be(nil)
      expect(movie.cast).to be(nil)
      expect(movie.total_reviews).to be(nil)
      expect(movie.reviews).to be(nil)
    end

    it "sets data correctly when full details is true" do
      movie = Movie.new(movie_json, full_details: true)

      expect(movie.id).to eq(1)
      expect(movie.title).to eq("Inception")
      expect(movie.vote_average).to eq(8.8)
      expect(movie.runtime).to eq(148)
      expect(movie.summary).to eq("A mind-bending thriller")
      expect(movie.cast).to eq([ {actor: "Leonardo DiCaprio", character: "Jack" }])
      expect(movie.total_reviews).to eq(5)
      expect(movie.reviews).to eq([ { author: "Jane", review: "Great movie"} ])
    end
  end
end