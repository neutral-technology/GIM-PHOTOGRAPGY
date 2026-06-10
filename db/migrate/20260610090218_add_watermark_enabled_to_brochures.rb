class AddWatermarkEnabledToBrochures < ActiveRecord::Migration[7.0]
  def change
    add_column :brochures, :watermark_enabled, :boolean, default: true, null: false
  end
end
