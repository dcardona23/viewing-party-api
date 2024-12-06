class MovieGateway
  def self.get_movies_by_search_param(query_term)
    response = conn.get("/3/search/movie?query=#{query_term}&page=1") 
    json = JSON.parse(response.body, symbolize_names: true)
    movies = json[:results] || []

    movies.map do |movie_json|
      Movie.new(movie_json)
    end
  end

  def self.get_movies_sorted_by_rating
    response = conn.get("/3/discover/movie?sort_by=vote_average.desc&page=1") 
    json = JSON.parse(response.body, symbolize_names: true)
    movies = json[:results] || []

    movies.map do |movie_json|
      Movie.new(movie_json)
    end
  end

  def self.get_movie_by_id(id)
    response = conn.get("/3/movie/#{id}") 
    json = JSON.parse(response.body, symbolize_names: true)
    
    if json[:success] == false
      raise ActiveRecord::RecordNotFound, "Movie with Id #{id} not found"
    end

    Movie.new(json)
  end

  def self.get_movie_by_id_full(id)
    response1 = conn.get("/3/movie/#{id}") 
    response2 = conn.get("3/movie/#{id}/credits")
    response3 = conn.get("3/movie/#{id}/reviews")

    json1 = JSON.parse(response1.body, symbolize_names: true)
    json2 = JSON.parse(response2.body, symbolize_names: true)
    json3 = JSON.parse(response3.body, symbolize_names: true)
    
    if json1[:success] == false
      raise ActiveRecord::RecordNotFound, "Movie with Id #{id} not found"
    end

    limited_cast = json2[:cast].first(10).map do |cast_member| {
      character: cast_member[:character],
      actor: cast_member[:name]
    }
    end

    limited_reviews = json3[:results].first(5).map do |review| {
      author: review[:author],
      review: review[:content]
    }
    end

    release_date_string = json1[:release_date]
    release_date = Date.parse(release_date_string)
    release_year = release_date.year
    
    movie_data = {
      id: json1[:id],
      title: json1[:title],
      release_year: release_year,
      vote_average: json1[:vote_average],
      runtime: json1[:runtime],
      summary: json1[:overview],
      cast: limited_cast,
      total_reviews: json3[:results].length,
      reviews: limited_reviews
    }

    movie_data
  end

  private

  def self.conn
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
    end
  end
end