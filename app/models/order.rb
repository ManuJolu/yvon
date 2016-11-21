class Order < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  has_many :ordered_meals
  has_many :meals through: :ordered_meals
end
