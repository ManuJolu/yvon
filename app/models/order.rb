class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant, required: true
  has_many :ordered_meals
  has_many :meals through: :ordered_meals
end
