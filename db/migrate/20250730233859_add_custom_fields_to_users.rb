class AddCustomFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string
    add_column :users, :city, :string
    add_column :users, :sex, :string
    add_column :users, :unique_id, :string
    add_index :users, :unique_id, unique: true # Ensure unique_id is unique
  end
end
