class Client < ApplicationRecord
  belongs_to :user
  has_many :receipts, dependent: :nullify
  has_one :album, dependent: :destroy

  # has_many :albums, dependent: :destroy
  validates :name, presence: true
  scope :vip_for, lambda { |user|
    where(fidelity_points: (user.vip_threshold / 100)..)
  }

  def vip_threshold_points
    (user.vip_threshold / 100).to_i
  end

  def recalculate_fidelity!
    update!(
      fidelity_level: fidelity_points >= vip_threshold_points ? 'vip' : 'normal'
    )
  end

  def points_remaining
    [vip_threshold_points - fidelity_points, 0].max
  end

  def vip?
    fidelity_level == 'vip'
  end

  def total_spent_fc
    receipts.sum(:amount)
  end

  def total_photos
    receipts.sum(:photos_count)
  end
end
