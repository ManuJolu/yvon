class MenuMealCategory < ApplicationRecord
  belongs_to :menu, required: true
  belongs_to :meal_category, required: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
