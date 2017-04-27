class Meal < ApplicationRecord
  belongs_to :meal_category
  has_one :restaurant, through: :meal_category
  has_many :meal_options, dependent: :destroy
  has_many :options, -> { order(position: :asc) }, through: :meal_options

  validates :tax_rate, presence: true

  include Mobility
  translates :name, type: :string, fallbacks: true, locale_accessors: [:fr, :en]
  translates :description, type: :string, fallbacks: true, locale_accessors: [:fr, :en]

  acts_as_list scope: :meal_category

  monetize :price_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }
  monetize :tax_cents
  monetize :pretax_price_cents

  enum tax_rate: [ '10', '20' ]

  has_attachment :photo

  scope :by_position, -> { order(position: :asc) }
  scope :are_active, -> { by_position.where(active: true) }

  def tax_cents
    if price_cents.present? && tax_rate.present?
      price_cents * tax_rate.to_f / (100 + tax_rate.to_f)
    else
      0
    end
  end

  def pretax_price_cents
    if price_cents.present? && tax_rate.present?
      price_cents / (1 + (tax_rate.to_f / 100))
    else
      price_cents
    end
  end
end
