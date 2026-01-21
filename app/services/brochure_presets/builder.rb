module BrochurePresets
  class Builder
    def self.build!(brochure:, preset:)
      layouts_for(preset.name).each_with_index do |layout, index|
        page = brochure.pages.create!(
          layout: layout,
          position: index + 1,
          brochure_preset: preset
        )

        create_blocks_for(page, layout)
      end
    end

    def self.layouts_for(preset_name)
      case preset_name
      when "Anniversaire"
        %w[cover story gallery closing]
      when "Dot"
        %w[cover family_story gallery traditions closing]
      when "Valentine"
        %w[cover love_story gallery message closing]
      else
        %w[cover story gallery closing]
      end
    end

    def self.create_blocks_for(page, layout)
      case layout
      when "cover"
        page.blocks.create!(block_type: "image")
        page.blocks.create!(block_type: "title", content: "Notre Jour Special")
        page.blocks.create!(block_type: "paragraph", content: "Une histoire inoubliable.")
      when "story", "love_story", "family_story"
        page.blocks.create!(block_type: "title", content: "Notre Histoire")
        page.blocks.create!(block_type: "paragraph", content: "Ecrivez votre histoire ici...")
      when "gallery"
        4.times { page.blocks.create!(block_type: "image") }
      when "closing"
        page.blocks.create!(block_type: "paragraph", content: "Thank you for being part of this moment.")
      end
    end
  end
end
