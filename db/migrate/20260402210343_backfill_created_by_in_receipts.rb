class BackfillCreatedByInReceipts < ActiveRecord::Migration[7.0]
  def up
    # Make sure Rails knows about the new column
    Receipt.reset_column_information

    default_photographer = Photographer.first
    raise "No photographers found. Please seed at least one." unless default_photographer

    Receipt.find_each do |receipt|
      next if receipt.created_by_id.present?

      receipt.update_columns(
        created_by_id: receipt.photographer_id || default_photographer.id
      )
    end
  end

  def down
    Receipt.update_all(created_by_id: nil)
  end
end
