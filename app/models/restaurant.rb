class Restaurant < ApplicationRecord
  belongs_to :user, required: true
  has_many :meals
  has_many :orders
  has_many :ordered_meals, through: :orders

  validates :name, presence: true
  validates :address, presence: true
  validates :category, presence: true
  validates :description, presence: true
  validates :photo, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?
end
