class CreateBrochureBlocks < ActiveRecord::Migration[7.0]
  def change
    create_table :brochure_blocks do |t|
      t.references :brochure_page, null: false, foreign_key: true
      t.string :block_type
      t.text :content
      t.integer :photo_id

      t.timestamps
    end
  end
end
