class Option < ApplicationRecord
  belongs_to :restaurant
  has_many :meal_options, dependent: :destroy

  validates :name, presence: true

  acts_as_list scope: :restaurant

  scope :are_active, -> { where(active: true) }
end
