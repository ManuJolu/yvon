class Meal < ApplicationRecord
  belongs_to :restaurant, required: true

  validates :name, presence: true
  validates :price, presence: true
  validates :photo, presence: true

  enum category: [ :starters, :main_courses, :desserts, :drinks ]
  enum tax: [ "2.1", "5.5", "10", "20" ]

  has_attachment :photo
end
