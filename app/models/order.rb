class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant, required: true
  has_many :ordered_meals
  has_many :meals, through: :ordered_meals

  def price
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.price }
  end

  def tax
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.tax }
  end

  def pretax_price
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.pretax_price }
  end
end
