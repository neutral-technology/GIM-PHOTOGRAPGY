class AddFidelityPointsToReceipts < ActiveRecord::Migration[7.0]
  def change
    add_column :receipts, :fidelity_points, :integer
  end
end
