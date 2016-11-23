class RestaurantController
  def initialize
    @view = RestaurantView.new
  end

  def index(message)
    lat = message.attachments[0]['payload']['coordinates']['lat']
    lng = message.attachments[0]['payload']['coordinates']['long']
    coordinates = [lat, lng]
    restaurants = Restaurant.where.not(latitude: nil, longitude: nil).near(coordinates, 1)
    @view.index(message, coordinates, restaurants)
  end
end
