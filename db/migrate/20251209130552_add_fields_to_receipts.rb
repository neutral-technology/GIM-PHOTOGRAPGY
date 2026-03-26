class AddFieldsToReceipts < ActiveRecord::Migration[7.0]
  def change
    add_reference :receipts, :client, null: false, foreign_key: true
    add_reference :receipts, :album, null: false, foreign_key: true
    add_column :receipts, :currency, :integer
    add_column :receipts, :amount_paid, :decimal
    add_column :receipts, :balance, :decimal
    add_column :receipts, :exchange_rate, :decimal, precision: 15, scale: 4, default: 1.0
    add_column :receipts, :paid_currency, :integer, default: 0 # currency of money received
    add_column :receipts, :serial_code, :string, null: false, unique: true
    add_index :receipts, :serial_code, unique: true
  end
end
