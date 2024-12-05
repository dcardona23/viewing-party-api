class MovieSerializer
  include JSONAPI::Serializer

  def self.format_movies(movies)
    { 
      data: movies.map do |movie|
      {
        id: movie.id.to_s, 
        type: "movie",
        attributes: {
          title: movie.title,
          vote_average: movie.vote_average
        }
      }
    end
  }
  end

  def self.format_movie(movie)
    { 
      data: 
      {
        id: movie.id.to_s, 
        type: "movie",
        attributes: {
          title: movie.title, 
          vote_average: movie.vote_average
        }
      }
    }
  end
end