class OrderedMeal < ApplicationRecord
  belongs_to :order, required: true
  belongs_to :meal, required: true
  belongs_to :option
  has_one :meal_category, through: :meal

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :by_meal_category, -> { joins(:meal_category).order('meal_categories.position', 'meals.position') }

  def self.at_timing(timing)
    joins(:meal_category).where(meal_categories: {timing: timing}).order('meals.position')
  end
end
