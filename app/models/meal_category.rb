class MealCategory < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :meals, -> { order(position: :asc) }, dependent: :restrict_with_exception
  has_one :active_meal, -> { where(active: true).order(position: :asc) }, class_name: 'Meal'

  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :timing, presence: true

  acts_as_list scope: :restaurant

  enum timing: [ :starter, :main_course, :dessert, :drink ]

  has_attachment :photo

  scope :are_active, -> { where(active: true) }

end
