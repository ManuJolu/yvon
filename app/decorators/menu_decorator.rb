class MenuDecorator < Draper::Decorator
  delegate_all

  def to_s
    "#{object.name} - #{price}"
  end

  def price
    humanized_money_with_symbol object.price
  end
end
