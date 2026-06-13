class CreateInvitationGuests < ActiveRecord::Migration[7.0]
  def change
    create_table :invitation_guests do |t|
      t.references :brochure, null: false, foreign_key: true
      t.string :name
      t.string :phone
      t.string :table
      t.string :token
      t.string :status, default: "pending"


      t.timestamps
    end
  end
end
