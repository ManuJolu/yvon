class RestaurantCategory < ApplicationRecord
  has_many :restaurants, dependent: :restrict_with_exception

  include Mobility
  translates :name, type: :string, fallbacks: true, locale_accessors: [:fr, :en]
end
