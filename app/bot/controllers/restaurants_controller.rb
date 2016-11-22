class RestaurantsController
  def initialize
    @view = RestaurantsView.new
  end

  def hello(message)
    @view.hello(message)
  end

  def index(message)
    lat = message.attachments[0]['payload']['coordinates']['lat']
    lng = message.attachments[0]['payload']['coordinates']['long']
    restaurants = Restaurant.where.not(latitude: nil, longitude: nil).near([lat, lng], 20)
    @view.index(message, restaurants)
  end
end
