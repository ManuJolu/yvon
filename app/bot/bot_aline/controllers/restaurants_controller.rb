class BotAline::RestaurantsController
  def initialize(message, user)
    @message = message
    @user = user
    @view = BotAline::RestaurantsView.new(message, user)
  end

  def index
    latitude = message.attachments[0]['payload']['coordinates']['lat']
    longitude = message.attachments[0]['payload']['coordinates']['long']
    coordinates = [latitude, longitude]
    restaurants = Restaurant.where.not(latitude: nil, longitude: nil).near(coordinates, 1).limit(10)
    view.index(coordinates, restaurants) if restaurants.present?
  end

  def login(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    view.logout(restaurant.messenger_user, restaurant, user) if restaurant.messenger_user
    restaurant.update(messenger_user: user)
    view.login(restaurant)
  end

  private

  attr_reader :message, :user, :view
end
