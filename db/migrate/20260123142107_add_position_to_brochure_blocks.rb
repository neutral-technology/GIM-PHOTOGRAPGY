class AddPositionToBrochureBlocks < ActiveRecord::Migration[7.0]
  def change
    add_column :brochure_blocks, :position, :integer
    add_index :brochure_blocks, [:brochure_page_id, :position]
  end
end
