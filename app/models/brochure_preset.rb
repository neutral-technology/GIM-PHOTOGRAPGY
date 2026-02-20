class BrochurePreset < ApplicationRecord
  has_many :brochures

  PRESETS = {
    # --- WEDDING CATEGORY ---
    wedding_advanced: [
      { layout: 'advanced/p_1_cover',   blocks: %w[image title paragraph] },
      
      { layout: 'advanced/p_0_intro',   blocks: %w[title paragraph] },
      { layout: 'advanced/p_1_hero',    blocks: %w[image] },
      
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_4_grid',    blocks: %w[image image image image] },
      
      { layout: 'advanced/p_1_hero',    blocks: %w[image] },
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },
      
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },

      { layout: 'advanced/p_3_trio',    blocks: %w[image image image] },
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_4_grid',    blocks: %w[image image image image] },
      
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },
      
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },
      
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },
      { layout: 'advanced/p_0_back',    blocks: %w[title] }
    ],

    wedding_pro: [
      { layout: 'advanced/p_6_mosaic',  blocks: %w[image image image image image image] }
      # 24 Pages would go here, following a similar but longer pattern
    ],

    # --- DOTE CATEGORY ---
    dote_advanced: [
      { layout: 'advanced/p_1_cover',   blocks: %w[image title] },
      { layout: 'advanced/p_0_intro',   blocks: %w[title paragraph] },
      { layout: 'advanced/p_4_grid',    blocks: %w[image image image image] },
      { layout: 'advanced/p_6_mosaic',  blocks: %w[image image image image image image] },
      { layout: 'advanced/p_1_hero',    blocks: %w[image] },
      { layout: 'advanced/p_2_duo',     blocks: %w[image image] },
      { layout: 'advanced/p_6_mosaic',  blocks: %w[image image image image image image] },
      { layout: 'advanced/p_4_grid',    blocks: %w[image image image image] },
      { layout: 'advanced/p_1_hero',    blocks: %w[image] },
      { layout: 'advanced/p_3_trio',    blocks: %w[image image image] },
      { layout: 'advanced/p_1_impact',  blocks: %w[image] },
      { layout: 'advanced/p_0_back',    blocks: %w[title] }
    ],

    # --- DEFAULT ---
    default: [
      { layout: 'default/cover',   blocks: %w[image title] },
      { layout: 'default/story',   blocks: %w[paragraph image] },
      { layout: 'default/gallery', blocks: %w[image image image] }
    ]
  }.freeze

  # 1. Add a THEMES constant to match your PRESETS
  THEMES = {
    wedding: {
      'colors' => { 'primary' => '#AF9164', 'background' => '#FFFFF', 'text' => '#2D2926' },
      'fonts' => { 'main' => 'serif' }
    },
    dote: {
      'colors' => { 'primary' => '#8B5E3C', 'background' => '#FAF3E0', 'text' => '#3E2723' },
      'fonts' => { 'main' => 'Cormorant Garamond' }
    },
    default: {
      'colors' => { 'primary' => '#111827', 'background' => '#FFFFFF', 'text' => '#111827' },
      'fonts' => { 'main' => 'sans-serif' }
    }
  }.freeze

  def display_name
    case name.to_s.downcase
    when 'wedding_advanced' then "💎 Mariage - Gamme Advanced (12p)"
    when 'wedding_pro'      then "🔥 Mariage - Gamme PRO (24p)"
    when 'dote_advanced', "dote"    then "💎 Dot - Gamme Advanced (12p)"
    when 'dote_pro'         then "🔥 Dot - Gamme PRO (24p)"
    when 'default'          then "📄 Standard"
    else name.titleize
    end
  end

  # 2. Define the theme method so the Brochure can call it
  def theme
    # Matches 'wedding' from 'wedding_advanced' or 'wedding_pro'
    category = name.to_s.split('_').first.to_sym
    THEMES[category] || THEMES[:default]
  end

  def page_definitions
    PRESETS[name.to_sym] || PRESETS[:default]
  end
end
