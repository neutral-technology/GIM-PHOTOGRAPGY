class Receipt < ApplicationRecord
  belongs_to :user # the photographer who created it (optional but recommended)
  belongs_to :client # the client who paid for the photos
  belongs_to :album

  enum :shooting_type, {
    mariage: 0,
    shooting: 1,
    dote: 2,
    evenement: 3,
    anniversaire: 4,
    photo_passeport: 5,
    dv_lottery: 7,
    podcast: 8,
    autre: 9
  }

  enum :currency, { cdf: 0, usd: 1 }, prefix: :invoice
  enum :paid_currency, { cdf: 0, usd: 1 }, prefix: :paid

  validates :shooting_type, :currency, :amount, :date, :photos_count, presence: true
  validates :photos_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :amount_paid, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :exchange_rate, presence: true, if: :currencies_different?

  before_validation :generate_serial_code, on: :create
  before_save :calculate_balance

  # Convert balance into paid currency
  def balance_in_paid_currency
    return balance if currency == paid_currency

    convert_to_paid_currency(balance)
  end

  private

  def currencies_different?
    currency != paid_currency
  end

  # Convert an amount from invoice currency → paid currency
  def convert_to_paid_currency(value)
    return value if currency == paid_currency

    if currency == 'usd' && paid_currency == 'cdf'
      value * exchange_rate
    elsif currency == 'cdf' && paid_currency == 'usd'
      value / exchange_rate
    else
      value
    end
  end

  # Convert an amount from paid currency → invoice currency
  def convert_to_invoice_currency(value)
    return value if currency == paid_currency

    if currency == 'usd' && paid_currency == 'cdf'
      value / exchange_rate
    elsif currency == 'cdf' && paid_currency == 'usd'
      value * exchange_rate
    else
      value
    end
  end

  def calculate_balance
    paid_in_invoice_currency = convert_to_invoice_currency(amount_paid || 0)
    self.balance = amount - paid_in_invoice_currency
  end

  def generate_serial_code
    self.serial_code ||= loop do
      code = "R#{SecureRandom.hex(3).upcase}" # Example: R1A2B3C4
      break code unless Receipt.exists?(serial_code: code)
    end
  end
end
