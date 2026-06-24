class AddUniqueIndexToInvitationGuestTokens < ActiveRecord::Migration[7.0]
  def change
    add_index :invitation_guests, :token, unique: true
  end
end
