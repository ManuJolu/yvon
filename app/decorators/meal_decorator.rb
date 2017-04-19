class MealDecorator < Draper::Decorator
  delegate_all
  decorates_association :options

  def price
    humanized_money_with_symbol object.price
  end

  def price_num
    format '%.2f', object.price
  end
end
