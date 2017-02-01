class Meal < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :meal_options
  has_many :options, through: :meal_options

  validates :category, presence: true
  validates :name, presence: true
  validates :tax_rate, presence: true
  validates :photo, presence: true
  validates :meal_options, length: { maximum: 3 } # does not work

  monetize :price_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }
  monetize :tax_cents
  monetize :pretax_price_cents

  enum category: [ :starter, :main_course, :dessert, :drink ]
  enum tax_rate: [ "2.1", "5.5", "10", "20" ]

  has_attachment :photo

  scope :by_category, -> { order(:category).order('lower(name)') }
  scope :is_active, -> { where(active: true) }

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
