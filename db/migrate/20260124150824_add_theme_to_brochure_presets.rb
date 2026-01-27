class AddThemeToBrochurePresets < ActiveRecord::Migration[7.0]
  def change
    add_column :brochure_presets, :theme, :jsonb
  end
end
