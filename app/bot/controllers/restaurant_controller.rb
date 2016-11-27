class RestaurantController
  def initialize
    @view = RestaurantView.new
  end

  def index(message, coordinates)
    restaurants = Restaurant.where.not(latitude: nil, longitude: nil).near(coordinates, 1)
    @view.index(message, coordinates, restaurants)
  end
end
