class AddFieldsToClient < ActiveRecord::Migration[7.0]
  def change
    add_column :clients, :tel, :integer
  end
end
