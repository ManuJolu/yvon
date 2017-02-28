class OrderedMealDecorator < Draper::Decorator
  delegate_all
  decorates_association :meal

  def to_s
    str = "#{object.quantity} × #{object.meal.name}"
    str += " - #{object.option.name}" if object.option
    str
  end
end
