class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant, required: true
  has_many :ordered_meals
  has_many :meals, through: :ordered_meals

  def total_cost
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.price }
  end

  def total_tax
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.tax_amount }
  end

  def subtotal
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.gross_price }
  end
end
