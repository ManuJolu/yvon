class MenuMealCategory < ApplicationRecord
  belongs_to :menu, required: true
  belongs_to :meal_category, required: true
end
