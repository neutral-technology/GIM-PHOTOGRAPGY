class AddStatusChangedAtToExpenses < ActiveRecord::Migration[7.0]
  def change
    add_column :expenses, :status_changed_at, :datetime
  end
end
