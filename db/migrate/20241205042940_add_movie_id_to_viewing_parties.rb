class AddMovieIdToViewingParties < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:viewing_parties, :movie_id)
    add_column :viewing_parties, :movie_id, :integer
    end
  end
end
