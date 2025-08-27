class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :albums, dependent: :destroy
  has_many :clients, dependent: :destroy
  has_many :stories, dependent: :destroy
  has_many :public_images, dependent: :destroy
  has_many :receipts, dependent: :destroy

  # Add validations for new fields if necessary
  validates :full_name, presence: true, length: { maximum: 25 }
  validates :city, length: { maximum: 15 }
end
