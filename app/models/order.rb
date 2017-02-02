class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant
  has_many :ordered_meals
  has_many :meals, through: :ordered_meals
  has_many :meal_categories, through: :ordered_meals

  monetize :price_cents
  monetize :tax_cents
  monetize :pretax_price_cents

  scope :pending, ->{ where('paid_at IS NOT NULL').where(delivered_at: nil).order(paid_at: :desc) }
  scope :delivered, -> { where('delivered_at IS NOT NULL').order(delivered_at: :desc) }

  def price_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.price_cents }
  end

  def tax_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.tax_cents }
  end

  def pretax_price_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.pretax_price_cents }
  end

  def meal_categories_array
    array = []
    ordered_meals.each do |ordered_meal|
      ordered_meal.quantity.times { array << ordered_meal.meal_category }
    end
    array
  end

  def create_elements
    order.restaurant.menus.by_price.each do |menu|

    end
  end
end
