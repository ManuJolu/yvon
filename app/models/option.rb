class Option < ApplicationRecord
  belongs_to :restaurant
  has_many :meal_options, dependent: :destroy

  validates :name, presence: true
end
