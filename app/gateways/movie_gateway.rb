class MovieGateway
  def self.get_movies_by_search_param(query_term)
    response = conn.get("/3/search/movie?query=#{query_term}&page=1") 
    json = JSON.parse(response.body, symbolize_names: true)
    movies = json[:results] || []
  end

  def self.get_movies_sorted_by_rating(movies)
    response = conn.get("/3/discover/movie?sort_by=vote_average.desc&page=1") 
    json = JSON.parse(response.body, symbolize_names: true)
    movies = json[:results] || []
  end

  def self.get_movie_by_id(id)
    response = conn.get("/3/movie/#{id}") 
    json = JSON.parse(response.body, symbolize_names: true)
    movie = json
    movie
  end

  private

  def self.conn
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
    end
  end
end