class Menu < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :menu_meal_categories
  has_many :meal_categories, through: :menu_meal_categories

  monetize :price_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }
  monetize :tax_cents
  monetize :pretax_price_cents

  scope :by_price, -> { order(price_cents: :desc) }

  def tax_cents
    if price_cents.present? && tax_rate.present?
      price_cents * tax_rate.to_f / (100 + tax_rate.to_f)
    else
      0
    end
  end

  def pretax_price_cents
    if price_cents.present? && tax_rate.present?
      price_cents / (1 + (tax_rate.to_f / 100))
    else
      price_cents
    end
  end

  def meal_categories_array
    array = []
    menu_meal_categories.each do |menu_meal_category|
      menu_meal_category.quantity.times { array << menu_meal_category.meal_category }
    end
    array
  end
end
