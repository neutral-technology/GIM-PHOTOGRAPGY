class AddPublicToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :public, :boolean
  end
end
