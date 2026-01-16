class BrochurePage < ApplicationRecord
  belongs_to :brochure
  has_many :blocks, class_name: "BrochureBlock", dependent: :destroy

  default_scope { order(:position) }
end
