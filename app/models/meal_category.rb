class MealCategory < ApplicationRecord
  belongs_to :restaurant
  has_many :meals

  acts_as_list scope: :restaurant

  enum timing: [ :starter, :main_course, :dessert, :drink ]
end
