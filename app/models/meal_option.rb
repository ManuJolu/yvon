class MealOption < ApplicationRecord
  belongs_to :meal
  belongs_to :option

  accepts_nested_attributes_for :option, reject_if: :all_blank
end
