class Brochure < ApplicationRecord
  belongs_to :client
  belongs_to :user
  belongs_to :brochure_preset

  has_many :pages, class_name: "BrochurePage", dependent: :destroy

  enum status: {
    draft: "draft",
    awaiting_approval: "awaiting_approval",
    approved: "approved",
    printed: "printed"
  }
  
  after_create :generate_pages_from_preset
  
  private

  def generate_pages_from_preset
    brochure_preset.page_definitions.each_with_index do |page_def, index|
      page = pages.create!(
        layout: page_def[:layout],
        position: index + 1
      )

      page_def[:blocks].each do |block_type|
        page.blocks.create!(
          block_type: block_type
        )
      end
    end
  end

  
end
