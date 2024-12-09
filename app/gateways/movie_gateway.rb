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

    if response.status != 200 || json[:success] == false
      raise MovieNotFoundError, "Movie with Id #{id} not found"
    else
      Movie.new(json)
    end
  end

  def self.get_movie_by_id_full(id)
    movie = fetch_movie_data(id)

    movie_data = {
      id: movie[:id],
      title: movie[:title],
      release_year: get_movie_release_year(id),
      vote_average: movie[:vote_average],
      runtime: get_movie_runtime(id),
      genres: get_movie_genres(id),
      summary: movie[:overview],
      cast: get_cast_data(id),
      total_reviews: get_total_reviews(id),
      reviews: get_reviews_data(id)
    }
    movie_data
  end

  def self.get_movie_runtime_raw(movie_id)
    movie_data = fetch_movie_data(movie_id)
    movie_data[:runtime]
  end

  private

  def self.conn
    Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
    end
  end

  def self.format_release_year(release_date)
    release_date = Date.parse(release_date)
    release_date.year
  end

  def self.get_cast_data(id)
    cast = fetch_movie_credits(id)[:cast]
    get_limited_cast(cast)
  end

  def self.get_limited_cast(cast)
    cast.first(10).map do |cast_member| 
      { character: cast_member[:character], actor: cast_member[:name] }
    end
  end

  def self.get_reviews_data(id)
    reviews = fetch_movie_reviews(id)[:results]
    get_limited_reviews(reviews)
  end

  def self.get_total_reviews(id)
    fetch_movie_reviews(id)[:results].length
  end

  def self.get_limited_reviews(reviews)
    reviews.first(5).map do |review| 
      { author: review[:author], review: review[:content] }
    end
  end

  def self.get_movie_release_year(id)
    release_date = fetch_movie_data(id)[:release_date]
    format_release_year(release_date)
  end

  def self.get_movie_genres(id)
    fetch_movie_data(id)[:genres].map { |genre| genre[:name] }
  end

  def self.get_movie_runtime(movie_id)
    movie_data = fetch_movie_data(movie_id)
    minutes = movie_data[:runtime]
    format_runtime(minutes) 
  end

  def self.format_runtime(minutes)
    hours = minutes/60
    remaining_minutes = minutes.remainder(60)

    "#{hours} hour#{"s" if hours > 1}, #{remaining_minutes} minute#{"s" if remaining_minutes > 1}"
  end

  def self.fetch_movie_data(id)
    response = conn.get("/3/movie/#{id}") 
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.fetch_movie_credits(id)
    response = conn.get("/3/movie/#{id}/credits") 
    JSON.parse(response.body, symbolize_names: true)
  end

  def self.fetch_movie_reviews(id)
    response = conn.get("/3/movie/#{id}/reviews") 
    JSON.parse(response.body, symbolize_names: true)
  end
end