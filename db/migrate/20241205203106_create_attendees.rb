class CreateAttendees < ActiveRecord::Migration[7.1]
  def change
    create_table :attendees do |t|
      t.references :users, null: false, foreign_key: true
      t.references :viewing_parties, null: false, foreign_key: true
      t.boolean :is_host
      t.string :name
      t.string :username

      t.timestamps
    end
  end
end
