class Album < ApplicationRecord
  belongs_to :user
  belongs_to :client
  has_many :images, dependent: :destroy
  
  # Active Storage attachment for the album's cover photo
  has_one_attached :cover_photo

  # Requires the `bcrypt` gem
  has_secure_password
  
  # For clean URLs like /albums/wedding-photos instead of /albums/1
  extend FriendlyId
  friendly_id :name, use: :slugged
  

  # Basic validations to ensure a password is set
  # Basic validations to ensure a password is set
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  validates :password, length: { minimum: 6 }, allow_blank: true, on: :update
  validates :name, presence: true
end
