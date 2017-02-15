class Restaurant < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant_category, required: true
  has_many :meals, dependent: :destroy
  has_many :meal_categories, -> { order(position: :asc) }, dependent: :destroy
  has_many :menus, -> { order(position: :asc) }, dependent: :destroy
  has_many :orders, dependent: :restrict_with_exception
  has_many :ordered_meals, through: :orders
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :meal_categories, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :menus, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :slogan, presence: true
  validates :address, presence: true
  validates :photo, presence: true
  validates :preparation_time, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_attachment :photo

  scope :on_duty, -> { where(on_duty: true) }

  def on_duty?
    on_duty
  end
end
