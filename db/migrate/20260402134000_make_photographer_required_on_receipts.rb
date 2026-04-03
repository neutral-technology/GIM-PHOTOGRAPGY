class MakePhotographerRequiredOnReceipts < ActiveRecord::Migration[7.0]
  def change
    def change
      change_column_null :receipts, :photographer_id, false
    end
  end
end
