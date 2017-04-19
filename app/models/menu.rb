class Menu < ApplicationRecord
  belongs_to :restaurant, required: true
  has_many :menu_meal_categories, dependent: :destroy
  has_many :meal_categories, through: :menu_meal_categories

  accepts_nested_attributes_for :menu_meal_categories, reject_if: :all_blank, allow_destroy: true

  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validates :tax_rate, presence: true

  acts_as_list scope: :restaurant

  monetize :price_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }
  monetize :tax_cents
  monetize :pretax_price_cents

  scope :by_price, -> { order(price_cents: :desc) }

  enum tax_rate: [ '10', '20' ]

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
