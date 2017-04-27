class MealCategory < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :meals, -> { order(position: :asc) }, dependent: :restrict_with_exception
  has_one :active_meal, -> { where(active: true).order(position: :asc) }, class_name: 'Meal'
  has_many :active_meals, -> { where(active: true).order(position: :asc).limit(9) }, class_name: 'Meal'

  validates :timing, presence: true

  include Mobility
  translates :name, type: :string, fallbacks: true, locale_accessors: [:fr, :en]

  acts_as_list scope: :restaurant

  enum timing: [ :starter, :main_course, :dessert, :drink ]

  has_attachment :photo

  scope :are_active, -> { where(active: true) }

end
