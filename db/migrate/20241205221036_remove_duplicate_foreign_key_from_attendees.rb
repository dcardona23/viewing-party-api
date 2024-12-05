class RemoveDuplicateForeignKeyFromAttendees < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :attendees, name: "fk_rails_c15cefbcf5"
  end
end
