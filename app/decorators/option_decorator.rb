class OptionDecorator < Draper::Decorator
  delegate_all

  def to_s
    str = object.to_label
    str += " (inact.)" unless object.active
    str
  end

  def price
    humanized_money_with_symbol object.price
  end
end
