class Image < ApplicationRecord
  belongs_to :album
  has_one_attached :photo

  # Ensure an image is attached
  validates :photo, presence: true

  # Check if expired (48h passed since download)
  def expired?
    downloaded_at.present? && downloaded_at <= 48.hours.ago
  end

  # Mark as downloaded now
  def mark_downloaded!
    update(downloaded_at: Time.current)
  end
end
