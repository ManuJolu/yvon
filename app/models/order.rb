class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant
  has_many :ordered_meals, dependent: :restrict_with_exception
  has_many :meals, through: :ordered_meals
  has_many :options, through: :ordered_meals
  has_many :meal_categories, through: :ordered_meals

  monetize :price_cents
  monetize :tax_cents
  monetize :pretax_price_cents

  enum payment_method: [ :pending, :credit_card, :counter, :demo ]

  scope :at_today, -> { where('sent_at > ?', Date.today.to_time).order(sent_at: :desc) }
  scope :to_deliver, -> { where('sent_at IS NOT NULL').where(delivered_at: nil).order(sent_at: :desc) }
  scope :are_delivered, -> { where('delivered_at IS NOT NULL').order(delivered_at: :desc) }

  def price_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.price_cents }
  end

  def tax_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.tax_cents }
  end

  def pretax_price_cents
    ordered_meals.sum { |ordered_meal| ordered_meal.quantity * ordered_meal.meal.pretax_price_cents }
  end
end
