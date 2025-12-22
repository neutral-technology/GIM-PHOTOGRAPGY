class Tarif < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  enum service: {
    mariage: 0,
    shooting: 1,
    dote: 2,
    evenement: 3,
    anniversaire: 4,
    photo_passeport: 5,
    dv_lottery: 6,
    podcast: 7,
    location: 8,
    salle: 9,
    autres: 10
  }

  enum :currency, { cdf: 0, usd: 1 }
  before_validation :set_default_currency

  validates :service, :price, :currency, presence: true
  validates :service, uniqueness: { scope: :user_id }
  validates :price, numericality: { greater_than: 0 }

  private

  def set_default_currency
    self.currency ||= "cdf"
  end
end
