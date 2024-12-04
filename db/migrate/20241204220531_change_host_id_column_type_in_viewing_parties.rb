class ChangeHostIdColumnTypeInViewingParties < ActiveRecord::Migration[7.1]
  def change
    change_column :viewing_parties, :host_id, :integer
  end
end
