class CreateBrochures < ActiveRecord::Migration[7.0]
  def change
    create_table :brochures do |t|
      t.string :title
      t.string :ceremony_type
      t.string :status
      t.references :client, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.datetime :published_at

      t.timestamps
    end
  end
end
