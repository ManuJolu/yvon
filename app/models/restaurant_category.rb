class RestaurantCategory < ApplicationRecord
  has_many :restaurants, dependent: :restrict_with_exception

  validates :name, presence: true

  default_scope { order(name: :asc) }
end
