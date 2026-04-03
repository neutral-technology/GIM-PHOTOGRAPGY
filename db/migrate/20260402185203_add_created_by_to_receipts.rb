class AddCreatedByToReceipts < ActiveRecord::Migration[7.0]
  def change
  add_reference :receipts, :created_by, foreign_key: { to_table: :photographers }, null: true  end
end
