class Image < ApplicationRecord
  belongs_to :album
  has_one_attached :photo
  
  # Ensure an image is attached
  validates :photo, presence: true
end