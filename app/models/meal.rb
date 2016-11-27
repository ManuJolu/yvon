class Meal < ApplicationRecord
  belongs_to :restaurant, required: true

  validates :category, presence: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, presence: true
  validates :photo, presence: true

  enum category: [ :starter, :main_course, :dessert, :drink ]
  enum tax_rate: [ "2.1", "5.5", "10", "20" ]

  has_attachment :photo

  def tax
    if tax_rate.present?
      price * tax_rate.to_f / (100 + tax.to_f)
    else
      0
    end
  end

  def pretax_price
    if tax_rate.present?
      price / (1 + (tax_rate.to_f / 100))
    else
      price
    end
  end
end
