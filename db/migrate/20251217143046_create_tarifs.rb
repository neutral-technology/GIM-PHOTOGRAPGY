class CreateTarifs < ActiveRecord::Migration[7.0]
  def change
    create_table :tarifs do |t|
      t.integer :service
      t.decimal :price
      t.string :note
      t.boolean :active

      t.timestamps
    end
  end
end
