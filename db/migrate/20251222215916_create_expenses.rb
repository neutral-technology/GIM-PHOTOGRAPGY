class CreateExpenses < ActiveRecord::Migration[7.0]
  def change
    create_table :expenses do |t|
      t.references :user, null: false, foreign_key: true
      t.decimal :amount
      t.integer :currency
      t.integer :category
      t.string :note
      t.integer :status, default: 0, null: false
      t.date :expense_date

      t.timestamps
    end
  end
end
