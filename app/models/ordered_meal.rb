class OrderedMeal < ApplicationRecord
  belongs_to :order, required: true
  belongs_to :meal, required: true
end
