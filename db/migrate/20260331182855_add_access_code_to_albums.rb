class AddAccessCodeToAlbums < ActiveRecord::Migration[7.0]
  def change
    add_column :albums, :access_code, :string
  end
end
