class CreateViewingParties < ActiveRecord::Migration[7.1]
  def change
    create_table :viewing_parties do |t|
      t.string :name
      t.string :start_time
      t.string :end_time
      t.string :string
      t.integer :movie_id
      t.string :movie_title

      t.timestamps
    end
  end
end
