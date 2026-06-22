class AddSentAtToInvitationGuests < ActiveRecord::Migration[7.0]
  def change
    add_column :invitation_guests, :sent_at, :datetime
  end
end
