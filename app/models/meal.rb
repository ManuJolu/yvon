class Meal < ApplicationRecord
  belongs_to :restaurant, required: true

  validates :name, presence: true
  validates :price, presence: true
  validates :photo, presence: true

  enum category: [ :starter, :main_course, :dessert, :drink ]
  enum tax: [ "2.1", "5.5", "10", "20" ]

  has_attachment :photo
end
