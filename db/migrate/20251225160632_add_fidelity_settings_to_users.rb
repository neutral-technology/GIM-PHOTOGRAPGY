class AddFidelitySettingsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :vip_threshold, :integer
  end
end
