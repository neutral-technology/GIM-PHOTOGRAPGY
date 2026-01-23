class AddBrochurePresetToBrochurePages < ActiveRecord::Migration[7.0]
  def change
    add_reference :brochure_pages, :brochure_preset, null: false, foreign_key: true
  end
end
