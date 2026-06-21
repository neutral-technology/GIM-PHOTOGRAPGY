class BrochurePage < ApplicationRecord
  belongs_to :brochure
  # belongs_to :brochure_preset, optional: true
  has_many :blocks, class_name: 'BrochureBlock', dependent: :destroy

  validates :layout, presence: true
  default_scope { order(:position) }
end
