class AddPhotographerToReceipts < ActiveRecord::Migration[7.0]
  def change
    add_reference :receipts, :photographer, null: true, foreign_key: true
  end
end
