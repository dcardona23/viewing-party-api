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

  def self.get_movie_runtime(id)
    response1 = conn.get("/3/movie/#{id}") 
    json = JSON.parse(response1.body, symbolize_names: true)
    json[:runtime]
  end

  def self.get_movie_by_id_full(id)
    response1 = conn.get("/3/movie/#{id}") 
    response2 = conn.get("3/movie/#{id}/credits")
    response3 = conn.get("3/movie/#{id}/reviews")

    json1 = JSON.parse(response1.body, symbolize_names: true)
    json2 = JSON.parse(response2.body, symbolize_names: true)
    json3 = JSON.parse(response3.body, symbolize_names: true)

    cast = json2[:cast]
    limited_cast = get_limited_cast(cast)

    reviews = json3[:results]
    limited_reviews = get_limited_reviews(reviews)

    release_date = json1[:release_date]
    release_year = format_release_year(release_date)

    genres = json1[:genres].map { |genre| genre[:name] }

    minutes = json1[:runtime]
    runtime_final = format_runtime(minutes)

    movie_data = {
      id: json1[:id],
      title: json1[:title],
      release_year: release_year,
      vote_average: json1[:vote_average],
      runtime: runtime_final,
      genres: genres,
      summary: json1[:overview],
      cast: limited_cast,
      total_reviews: json3[:results].length,
      reviews: limited_reviews
    }
    movie_data
  end

  def self.get_limited_cast(cast)
    cast.first(10).map do |cast_member| {
      character: cast_member[:character],
      actor: cast_member[:name]
    }
    end
  end

  def self.get_limited_reviews(reviews)
    reviews.first(5).map do |review| {
      author: review[:author],
      review: review[:content]
    }
    end
  end

  def self.format_runtime(minutes)
    hours = minutes/60
    remaining_minutes = minutes.remainder(60)

    "#{hours} hour#{"s" if hours > 1}, #{remaining_minutes} minute#{"s" if remaining_minutes > 1}"
  end

  def self.format_release_year(release_date)
    release_date = Date.parse(release_date)
    release_date.year
  end

  private

  def self.conn
    conn = Faraday.new(url: "https://api.themoviedb.org") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{Rails.application.credentials.tmdb[:key]}"
    end
  end
end