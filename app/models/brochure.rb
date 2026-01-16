class Brochure < ApplicationRecord
  belongs_to :client
  belongs_to :user

  has_many :pages, class_name: "BrochurePage", dependent: :destroy

  enum status: {
    draft: "draft",
    awaiting_approval: "awaiting_approval",
    approved: "approved",
    printed: "printed"
  }
end
