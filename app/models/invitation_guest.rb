class InvitationGuest < ApplicationRecord
  belongs_to :brochure
  before_validation :generate_token, on: :create
  validates :name, :phone, :table, presence: true

  enum :status, {
    pending: "pending",
    accepted: "accepted",
    declined: "declined"
  }
  def accept!
    update!(
      status: :accepted,
      accepted_at: Time.current
    )
  end

  def decline!
    update!(
      status: :declined,
      accepted_at: nil
    )
  end

  def checked_in?
    checked_in_at.present?
  end

  def check_in!
    update!(
      checked_in_at: Time.current
    )
  end

  def mark_as_sent!
    update!(
      sent_at: Time.current
    )
  end

  def sent?
    sent_at.present?
  end

  private

  def generate_token
    self.token ||= SecureRandom.hex(8)
  end
end
