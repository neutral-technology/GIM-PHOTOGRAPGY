class AddCheckInToInvitationGuests < ActiveRecord::Migration[7.0]
  def change
    add_column :invitation_guests, :accepted_at, :datetime
    add_column :invitation_guests, :checked_in, :boolean, default: false
  end
end
