class RestaurantController
  def initialize
    @view = RestaurantView.new
  end

  def index(message)
    lat = message.attachments[0]['payload']['coordinates']['lat']
    lng = message.attachments[0]['payload']['coordinates']['long']
    restaurants = Restaurant.where.not(latitude: nil, longitude: nil).near([lat, lng], 20)
    @view.index(message, restaurants)
  end
end
