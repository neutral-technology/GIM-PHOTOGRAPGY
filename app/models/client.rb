class Client < ApplicationRecord
  belongs_to :user
  has_one :album, dependent: :destroy

  # has_many :albums, dependent: :destroy
  validates :name, presence: true
end
