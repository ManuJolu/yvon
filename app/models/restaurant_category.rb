class RestaurantCategory < ApplicationRecord
  has_many :restaurants, dependent: :restrict_with_exception

  include Mobility
  translates :name, type: :string, fallbacks: { en: :fr }, locale_accessors: [:fr, :en]

  default_scope { order(name_ut: :asc) }
end
