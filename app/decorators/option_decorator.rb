class OptionDecorator < Draper::Decorator
  delegate_all

  def to_s
    str = to_label
    str += " (inact.)" unless active
    str
  end

  def signed_price
    to_label.capitalize
  end

  def unsigned_price
    "#{name.capitalize} : #{price}"
  end

  def price
    humanized_money_with_symbol object.price
  end
end
