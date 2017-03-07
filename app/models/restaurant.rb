class Restaurant < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :restaurant_category, required: true
  belongs_to :messenger_user, class_name: 'User'
  has_many :meals, dependent: :destroy
  has_many :meal_categories, -> { order(position: :asc) }, dependent: :destroy
  has_many :menus, -> { order(position: :asc) }, dependent: :destroy
  has_many :orders, dependent: :restrict_with_exception
  has_many :ordered_meals, through: :orders
  has_many :options, -> { order(position: :asc) }, dependent: :destroy

  accepts_nested_attributes_for :meal_categories, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :options, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :menus, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true
  validates :about, presence: true
  validates :address, presence: true
  validates :photo, presence: true
  validates :preparation_time, presence: true
  validates :mode, presence: true
  validates :messenger_pass, format: { with: /\A\d{2}\z/,
    message: "2 chiffres" }, allow_nil: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_attachment :photo

  enum mode: [ :display_only, :order_acceptance ]

  scope :on_duty, -> { where(on_duty: true) }
  scope :by_orders, -> { joins(:orders).group('restaurants.id').order('count(restaurants.id) DESC') }

  def on_duty?
    on_duty
  end

  def star_rating
    ("★" * 4) + ("☆" * 1)
  end
end
