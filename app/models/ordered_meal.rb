class OrderedMeal < ApplicationRecord
  belongs_to :order, required: true
  belongs_to :meal, required: true
  belongs_to :option
  has_one :meal_category, through: :meal

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  monetize :price_cents

  scope :by_meal_category, -> { joins(:meal_category).order('meal_categories.timing', 'meal_categories.position', 'meals.position') }

  def self.at_timing(timing)
    by_meal_category.where(meal_categories: {timing: timing})
  end

  def price_cents
    meal.price_cents + option&.price_cents.to_i
  end

  def tax_cents
    if price_cents.present? && meal.tax_rate.present?
      price_cents * meal.tax_rate.to_f / (100 + meal.tax_rate.to_f)
    else
      0
    end
  end

  def pretax_price_cents
    if price_cents.present? && meal.tax_rate.present?
      price_cents / (1 + (meal.tax_rate.to_f / 100))
    else
      price_cents
    end
  end
end
