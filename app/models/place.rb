class Place < ApplicationRecord
  validates :name, presence: true
  validates :address, presence: true

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  has_attachment :photo

end
