class OrderElement < ApplicationRecord
  belongs_to :order
  belongs_to :element, polymorphic: true
end
