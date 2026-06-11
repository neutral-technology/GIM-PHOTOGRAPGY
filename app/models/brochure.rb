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

  enum :kind,{
    brochure:"brochure",
    invitation:"invitation"
  }

  after_create :generate_pages_from_preset
  after_create :auto_fill_images_from_album # Add this second callback

  def theme
    # 1. Take the base theme from the preset and force keys to strings
    base = brochure_preset.theme.deep_stringify_keys

    # 2. Take the overrides from the DB and force keys to strings
    # Use an empty hash if theme_overrides is nil
    overrides = (theme_overrides || {}).deep_stringify_keys

    # 3. Merge them (overrides will now correctly replace base keys)
    base.deep_merge(overrides)
  end

  def active_cover_layout
    custom_cover_layout.presence ||
      brochure_preset&.page_definitions&.first&.dig(:layout) ||
      'default/cover'
  end

  def show_watermark?
    watermark_enabled? && !approved? && !printed?
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

  def auto_fill_images_from_album
    album = client.album
    # Use .any? for a collection of models
    return if album.nil? || album.images.none?

    # 1. Get all image blocks created for this brochure
    # We find all blocks belonging to the pages of THIS brochure
    image_blocks = BrochureBlock.where(brochure_page_id: page_ids, block_type: 'image').order(:id)

    # 2. Get the photos from the album
    # Assuming your Image model has 'has_one_attached :file' or similar
    album_photos = album.images.order(:created_at).limit(image_blocks.count)

    image_blocks.each_with_index do |block, index|
      photo = album_photos[index]
      break unless photo

      # IMPORTANT: Change :file to whatever your attachment name is in your Image model
      if photo.photo.attached?
        block.image.attach(photo.photo.blob)
        block.save
      end
    end
  end
end
