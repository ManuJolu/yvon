class Meal < ApplicationRecord
  belongs_to :restaurant, required: true

  validates :category, presence: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax, presence: true
  validates :photo, presence: true

  enum category: [ :starter, :main_course, :dessert, :drink ]
  enum tax: [ "2.1", "5.5", "10", "20" ]

  has_attachment :photo

  def tax_amount
    if tax.present?
      price * tax.to_f / (100 + tax.to_f)
    else
      0
    end
  end

  def gross_price
    if tax.present?
      price / (1 + (tax.to_f / 100))
    else
      price
    end
  end
end
