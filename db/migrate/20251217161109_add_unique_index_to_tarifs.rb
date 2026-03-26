class AddUniqueIndexToTarifs < ActiveRecord::Migration[7.0]
  def change
      add_reference :tarifs, :user, null: false, foreign_key: true
      add_index :tarifs, [:user_id, :service], unique: true
  end
end
