class AddCheckedInAtToInvitationGuests < ActiveRecord::Migration[7.0]
  def change
    add_column :invitation_guests, :checked_in_at, :datetime
  end
end
