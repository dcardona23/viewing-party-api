class AddUserIdToViewingParties < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_parties, :user_id, :integer
    add_index :viewing_parties, :user_id
  end
end
