class BrochurePreset < ApplicationRecord
  has_many :brochures

  PRESETS = {
    wedding: [
      { layout: 'cover', blocks: %w[image title paragraph] },
      { layout: 'story', blocks: %w[title paragraph image] },
      { layout: 'full_image', blocks: %w[image] },
      { layout: 'gallery', blocks: %w[image image image] }
    ],

    anniversaire: [
      { layout: 'cover', blocks: %w[image title] },
      { layout: 'story', blocks: %w[paragraph image] },
            { layout: 'gallery', blocks: %w[image image image] }
    ],

    dote: [
      { layout: 'cover', blocks: %w[image title] },
      { layout: 'story', blocks: %w[paragraph] },
      { layout: 'gallery', blocks: %w[image image image] }
    ],

    valentine: [
      { layout: 'cover', blocks: %w[image title paragraph] },
      { layout: 'full_image', blocks: %w[image] },
      { layout: 'gallery', blocks: %w[image image image] }
    ],

    default: [
      { layout: 'cover', blocks: %w[image title] },
      { layout: 'story', blocks: %w[paragraph] },
      { layout: 'gallery', blocks: %w[image image image] }
    ]
  }.freeze

  # 1. Add a THEMES constant to match your PRESETS
  THEMES = {
    wedding: { 
      "colors" => { "primary" => "#d4af37", "background" => "#fffaf0", "text" => "#1a1a1a" },
      "fonts" => { "main" => "serif" }
    },
    valentine: { 
      "colors" => { "primary" => "#e11d48", "background" => "#fff1f2", "text" => "#4c0519" },
      "fonts" => { "main" => "sans-serif" }
    },
    default: { 
      "colors" => { "primary" => "#4361ee", "background" => "#ffffff", "text" => "#0e1726" },
      "fonts" => { "main" => "nunito" }
    }
  }.freeze

  # 2. Define the theme method so the Brochure can call it
  def theme
    THEMES[name.to_sym] || THEMES[:default]
  end

  def page_definitions
    PRESETS[name.to_sym] || PRESETS[:default]
  end
end
