class Receipt < ApplicationRecord
  belongs_to :user  # the photographer who created it (optional but recommended)

  enum shooting_type: {
    mariage: 0,
    shooting: 1,
    evenement: 2,
    anniversaire: 3,
    autre: 4
  }

  validates :shooting_type, :amount, :date, :photos_count, presence: true
  validates :photos_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
