class AddDownloadInfoToImages < ActiveRecord::Migration[7.0]
  def change
    add_column :images, :downloaded_at, :datetime
  end
end
