class Movie
  attr_reader :id,
              :title,
              :vote_average

  def initialize(movie_json, full_details: false)
    @id = movie_json[:id]
    @title = movie_json[:title]
    @vote_average = movie_json[:vote_average]
  
    if full_details
      @runtime = movie_json[:runtime],
      @summary = movie_json[:overview],
      @cast = movie_json[:cast],
      @total_reviews = movie_json[:results],
      @reviews = movie_json[:results]
    end
  end
end