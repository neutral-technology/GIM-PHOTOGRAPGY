class AddKindToBrochures < ActiveRecord::Migration[7.0]
  def change
    add_column :brochures, :kind, :string
  end
end
