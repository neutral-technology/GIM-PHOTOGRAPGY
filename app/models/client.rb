class Client < ApplicationRecord
  belongs_to :user
  has_many :receipts, dependent: :nullify
  has_one :album, dependent: :destroy
  # has_many :albums, dependent: :destroy
  validates :name, presence: true
  scope :vip_for, lambda { |user|
    where(fidelity_points: (user.vip_threshold / 100)..)
  }

  validates :tel, format: {
    with: /\A243\d{9}\z/,
    message: 'numéro invalide'
  }
  before_validation :normalize_tel
  before_save :sync_fidelity_level

  def vip_threshold_points
    return 1000 if user.vip_threshold.blank?

    (user.vip_threshold / 100).to_i
  end

  def points_remaining
    [vip_threshold_points - fidelity_points, 0].max
  end

  def vip?
    # fidelity_level == 'vip'
    (fidelity_points || 0) >= vip_threshold_points
  end

  def sync_fidelity_level
    self.fidelity_level = vip? ? 'vip' : 'normal'
  end

  def add_fidelity_points(points)
    with_lock do
      self.fidelity_points = (fidelity_points || 0) + points
      sync_fidelity_level
      save(validate: false)
    end
  end

  def total_spent_fc
    receipts.sum(:amount)
  end

  def total_photos
    receipts.sum(:photos_count)
  end

  def normalize_tel
    return if tel.blank?

    # remove spaces and non-digits
    cleaned = tel.gsub(/\D/, '')
    # remove leading 0 if present
    cleaned = cleaned.sub(/^0/, '')
    # ensure it starts with 243
    cleaned = "243#{cleaned}" unless cleaned.start_with?('243')
    self.tel = cleaned
  end
end
