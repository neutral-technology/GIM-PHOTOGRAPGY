class AddBrochurePresetToBrochures < ActiveRecord::Migration[7.0]
  def change
    add_reference :brochures, :brochure_preset, foreign_key: true
  end
end
