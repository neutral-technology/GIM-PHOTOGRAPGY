class AddNotNullToCreatedByInReceipts < ActiveRecord::Migration[7.0]
  def change
      change_column_null :receipts, :created_by_id, false
  end
end
