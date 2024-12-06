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

  def self.format_movie_full(movie)
    { 
      data: {
        id: movie[:id].to_s,
        type: "movie",
        attributes: {
          title: movie[:title],
          release_year: movie[:release_year],
          vote_average: movie[:vote_average],
          runtime: movie[:runtime],
          genres: movie[:genres],
          summary: movie[:summary],
          cast: movie[:cast],
          total_reviews: movie[:total_reviews],
          reviews: movie[:reviews]
        }
      }
    }
  end
end