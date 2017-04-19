class Option < ApplicationRecord
  belongs_to :restaurant
  has_many :meal_options, dependent: :destroy

  validates :name, presence: true

  acts_as_list scope: :restaurant

  monetize :price_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }

  scope :are_active, -> { where(active: true) }

  def to_label
    if price > 0
      "#{name} (+ #{humanized_money_with_symbol price})"
    else
      name
    end
  end
end
