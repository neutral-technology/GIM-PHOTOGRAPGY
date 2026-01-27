class Brochure < ApplicationRecord
  belongs_to :client
  belongs_to :user
  belongs_to :brochure_preset

  has_many :pages, class_name: 'BrochurePage', dependent: :destroy

  enum :status, {
    draft: 'draft',
    awaiting_approval: 'awaiting_approval',
    approved: 'approved',
    printed: 'printed'
  }

  after_create :generate_pages_from_preset

  def theme
    # 1. Take the base theme from the preset and force keys to strings
    base = brochure_preset.theme.deep_stringify_keys
    
    # 2. Take the overrides from the DB and force keys to strings
    # Use an empty hash if theme_overrides is nil
    overrides = (theme_overrides || {}).deep_stringify_keys
    
    # 3. Merge them (overrides will now correctly replace base keys)
    base.deep_merge(overrides)
  end

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
