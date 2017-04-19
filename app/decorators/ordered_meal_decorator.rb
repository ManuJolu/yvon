class OrderedMealDecorator < Draper::Decorator
  delegate_all
  decorates_association :meal

  def to_s
    str = "#{object.quantity} × #{object.meal.name}"
    str += " - #{object.option.name}" if object.option
    str
  end

  def price
    humanized_money_with_symbol object.price
  end

  def price_num
    format '%.2f', object.price
  end
end
