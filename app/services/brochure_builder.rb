class BrochureBuilder
  def self.from_preset(brochure:, preset:)
    preset.pages.each_with_index do |page_data, index|
      page = brochure.pages.create!(
        layout: page_data[:layout],
        position: index
      )

      page_data[:blocks].each do |block_data|
        page.blocks.create!(
          block_type: block_data[:block_type],
          content: block_data[:content]
        )
      end
    end

    brochure
  end
end
