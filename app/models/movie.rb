class Movie < ApplicationRecord
  validates :name, presence: true

  def self.sort_by_rating
    order('vote_average desc')
  end

  def self.filter_movies(scope, params)
    scope = scope.sort_by_rating if params[:highest] 
  end

end