class AddCustomCoverLayoutToBrochures < ActiveRecord::Migration[7.0]
  def change
    add_column :brochures, :custom_cover_layout, :string
  end
end
