class OrderedMeal < ApplicationRecord
  belongs_to :order, required: true
  belongs_to :meal, required: true
  belongs_to :option
  has_one :meal_category, through: :meal

  scope :by_category, -> { joins(:meal).merge(Meal.order(:category).order('lower(name)')) }

end
