class MealCategory < ApplicationRecord
  belongs_to :restaurant
  has_many :meals

  acts_as_list scope: :restaurant
end
