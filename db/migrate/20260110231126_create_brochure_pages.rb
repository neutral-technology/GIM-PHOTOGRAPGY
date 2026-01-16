class CreateBrochurePages < ActiveRecord::Migration[7.0]
  def change
    create_table :brochure_pages do |t|
      t.references :brochure, null: false, foreign_key: true
      t.integer :position
      t.string :layout

      t.timestamps
    end
  end
end
