class RestaurantController
  def initialize
    @view = RestaurantView.new
  end

  def index(message, coordinates)
    restaurants = Restaurant.on_duty.where.not(latitude: nil, longitude: nil).near(coordinates, 0.6).limit(10)
    @view.index(message, coordinates, restaurants)
  end
end
