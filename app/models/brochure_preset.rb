class BrochurePreset < ApplicationRecord
  has_many :brochures

  PRESETS = {
    wedding: [
      { layout: "cover", blocks: %w[image title paragraph] },
      { layout: "story", blocks: %w[title paragraph image] },
      { layout: "full_image", blocks: %w[image] },
      { layout: "gallery", blocks: %w[image image image] }
    ],

    anniversaire: [
      { layout: "cover", blocks: %w[image title] },
      { layout: "story", blocks: %w[paragraph image] }
    ],

    dote: [
      { layout: "cover", blocks: %w[image title] },
      { layout: "story", blocks: %w[paragraph] }
    ],

    valentine: [
      { layout: "cover", blocks: %w[image title paragraph] },
      { layout: "full_image", blocks: %w[image] }
    ],

    default: [
      { layout: "cover", blocks: %w[image title] },
      { layout: "story", blocks: %w[paragraph] }
    ]
  }

  def page_definitions
    PRESETS[name.to_sym] || PRESETS[:default]
  end
end
