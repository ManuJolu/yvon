class MealCategory < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :meals, -> { order(position: :asc) }, dependent: :restrict_with_exception

  validates :name, presence: true
  validates :timing, presence: true

  acts_as_list scope: :restaurant

  enum timing: [ :starter, :main_course, :dessert, :drink ]
end
