class AddHostIdToViewingParties < ActiveRecord::Migration[7.1]
  def change
    add_column :viewing_parties, :host_id, :integer
  end
end
