class RemoveStringColumnFromViewingParties < ActiveRecord::Migration[7.1]
  def change
    remove_column :viewing_parties, :string, :string
  end
end
