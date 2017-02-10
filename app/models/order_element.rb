class OrderElement < ApplicationRecord
  belongs_to :order
  belongs_to :element, polymorphic: true

  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
end
