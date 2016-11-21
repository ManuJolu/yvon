class Meal < ApplicationRecord
  belongs_to :restaurant, required: true

  validates :name, presence: true
  validates :price, presence: true
  validates :photo, presence: true
end
