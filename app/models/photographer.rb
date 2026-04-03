class Photographer < ApplicationRecord
  enum role: {
    photographer: 0,
    receptionist: 1
  }

  has_many :assigned_receipts, class_name: "Receipt", foreign_key: :photographer_id
  has_many :created_receipts, class_name: "Receipt", foreign_key: :created_by_id
  validates :name, presence: true
end