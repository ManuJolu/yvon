class Restaurant < ApplicationRecord
  belongs_to :user, required: true
  has_many :meals
  has_many :meal_categories, -> { order(position: :asc) }
  has_many :orders
  has_many :ordered_meals, through: :orders
  has_many :options

  validates :name, presence: true
  validates :address, presence: true
  validates :category, presence: true
  validates :description, presence: true
  validates :photo, presence: true
  validates :preparation_time, presence: true

  monetize :turnover_cents

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_attachment :photo

  enum category: [ :french, :burgers, :salads, :italian, :chinese, :japonese, :indian ]

  scope :on_duty, -> { where(on_duty: true) }

  def on_duty?
    on_duty
  end

  def turnover_cents
    orders.reduce(0) { |t, order| t + order.pretax_price_cents }
  end
end
