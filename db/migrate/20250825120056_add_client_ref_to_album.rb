class AddClientRefToAlbum < ActiveRecord::Migration[7.0]
  def change
    add_reference :albums, :client, null: false, foreign_key: true
  end
end
