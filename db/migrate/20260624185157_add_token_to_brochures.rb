class AddTokenToBrochures < ActiveRecord::Migration[7.0]
  def change
    add_column :brochures, :token, :string
    add_index :brochures, :token, unique: true
  end
end
