class RemoveHostIdFromViewingParties < ActiveRecord::Migration[7.1]
  def change
    remove_column :viewing_parties, :host_id
  end
end
