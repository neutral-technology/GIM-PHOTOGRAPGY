class Expense < ApplicationRecord
  belongs_to :user

  enum currency: {
    cdf: 0,
    usd: 1
  }

  enum category: {
    nourriture: 0,
    materiel: 1,
    divers: 2
  }

  enum status: {
    spent: 0, # normal expense
    refunded: 1, # money came back
    canceled: 2 # mistake / annulé
  }

  validates :amount, :currency, :category, :expense_date, presence: true
  before_validation :set_default_status, on: :create
  before_update :set_status_changed_at, if: :will_save_change_to_status?

  def status_label
    {
      "spent" => "dépensée",
      "refunded" => "remboursée",
      "canceled" => "annulée"
    }[status] || "dépensée"
  end

  private
  def set_status_changed_at
    self.status_changed_at = Time.current
  end
  def set_default_status
    self.status ||= "spent"
  end
end
