class MealCategoryDecorator < Draper::Decorator

delegate_all

  def to_s
    str = object.name
    str += " (inact.)" unless object.active
    str
  end

end
