class AddThemeOverridesToBrochures < ActiveRecord::Migration[7.0]
  def change
    add_column :brochures, :theme_overrides, :jsonb
  end
end
