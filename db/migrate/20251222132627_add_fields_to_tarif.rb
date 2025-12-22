class AddFieldsToTarif < ActiveRecord::Migration[7.0]
  def change
    add_column :tarifs, :currency, :integer
  end
end
