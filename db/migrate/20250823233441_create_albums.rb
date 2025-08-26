class CreateAlbums < ActiveRecord::Migration[7.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.string :password_digest
      t.string :slug
      t.references :user, null: false, foreign_key: true
      # t.references :client, null: false, foreign_key: true

      t.timestamps
    end
    add_index :albums, :slug, unique: true

  end
end
