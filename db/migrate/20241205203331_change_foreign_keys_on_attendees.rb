class ChangeForeignKeysOnAttendees < ActiveRecord::Migration[7.1]
  def change
    rename_column :attendees, :users_id, :user_id
    rename_column :attendees, :viewing_parties_id, :viewing_party_id

    add_foreign_key :attendees, :users, column: :user_id
    add_foreign_key :attendees, :viewing_parties, column: :viewing_party_id
  end
end
