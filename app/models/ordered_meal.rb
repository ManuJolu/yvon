class OrderedMeal < ApplicationRecord
  belongs_to :order, required: true
  belongs_to :meal, required: true

  scope :by_category, -> { joins(:meal).merge(Meal.order(:name).order(:category)) }

end
