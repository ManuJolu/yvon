class Option < ApplicationRecord
  belongs_to :restaurant
  has_many :meal_options, dependent: :destroy

  include Mobility
  translates :name, type: :string, fallbacks: true, locale_accessors: [:fr, :en]

  acts_as_list scope: :restaurant

  monetize :price_cents, allow_nil: false, numericality: { greater_than_or_equal_to: 0 }

  scope :are_active, -> { where(active: true) }
  scope :select_active, -> { select { |option| option.active} }

  def to_label
    price > 0 ? "#{name} (+ #{humanized_money_with_symbol price})" : name
  end
end
