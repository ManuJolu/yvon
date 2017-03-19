class MealCategory < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :meals, dependent: :restrict_with_exception

  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :timing, presence: true

  acts_as_list scope: :restaurant

  enum timing: [ :starter, :main_course, :dessert, :drink ]
end
