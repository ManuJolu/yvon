class OrderedMeal < ApplicationRecord
  belongs_to :order, required: true
  belongs_to :meal, required: true
  belongs_to :option
  has_one :meal_category, through: :meal

  scope :by_category, -> { joins(:meal).merge(Meal.order(:category).includes(:meal).order('lower(name)')) }

  def self.at_timing(timing)
    # select { |ordered_meal| ordered_meal.meal_category.timing == timing }
    # includes(:meal).includes(:meal_category).where('meal.meal_category.timing = ?', timing)
    joins(:meal_category).merge(MealCategory.where(timing: timing))
  end
end
