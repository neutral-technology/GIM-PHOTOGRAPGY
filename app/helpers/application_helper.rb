module ApplicationHelper
  def money(amount, currency)
    return "--" if amount.blank?

    # value = amount.to_d.normalize    
    case currency.to_s
    when "usd"
      number_to_currency(amount, unit: "$", precision: 2, strip_insignificant_zeros: true )
    when "cdf"
      number_to_currency(amount, unit: "FC", precision: 0, format: "%n %u")
    else
      number_to_currency(amount)
    end
  end
end
