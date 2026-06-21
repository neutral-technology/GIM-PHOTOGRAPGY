class RemoveBrochurePresetFromBrochurePages < ActiveRecord::Migration[7.0]
  def change
    remove_reference :brochure_pages, :brochure_preset
  end
end
