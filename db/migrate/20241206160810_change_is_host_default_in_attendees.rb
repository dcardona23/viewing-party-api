class ChangeIsHostDefaultInAttendees < ActiveRecord::Migration[7.1]
  def change
    change_column_default :attendees, :is_host, false
  end
end
