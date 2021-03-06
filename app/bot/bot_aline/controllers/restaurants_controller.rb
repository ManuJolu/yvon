class BotAline::RestaurantsController
  def initialize(message, user)
    @message = message
    @user = user
    @view = BotAline::RestaurantsView.new(message, user)
  end

  def pass(restaurant_id, params = {})
    if params[:attempt].size < 4
      view.pass(restaurant_id, params)
    else
      view.wrong_pass
    end
  end

  def verify_login(restaurant_id, params)
    restaurant = Restaurant.find(restaurant_id)
    if params[:attempt] == restaurant.messenger_pass
      user.messenger_restaurant&.update(messenger_user: nil)
      restaurant.reload
      BotAline::NotificationsController.new.logged_out(restaurant, user) if restaurant.messenger_user
      restaurant.update(messenger_user: user)
      user.reload
      view.logged_in(restaurant)
      BotAline::OrdersController.new(message, user).index
    else
      view.pass(restaurant_id, params)
    end
  end

  def index
    latitude = message.attachments[0]['payload']['coordinates']['lat']
    longitude = message.attachments[0]['payload']['coordinates']['long']
    coordinates = [latitude, longitude]
    restaurants = Restaurant.where.not(latitude: nil, longitude: nil).near(coordinates, 1).limit(10)
    view.index(coordinates, restaurants) if restaurants.present?
  end

  def duty
    restaurant = user.messenger_restaurant
    view.duty(restaurant)
  end

  def update_duty(restaurant_id, duty)
    restaurant = Restaurant.find(restaurant_id)
    restaurant.on_duty = (duty == 'on' ? true : false)
    restaurant.save
    ActionCable.server.broadcast "restaurant_#{restaurant.id}",
      update: "duty"
  end

  def preparation_time
    restaurant = user.messenger_restaurant
    view.preparation_time(restaurant)
  end

  def update_preparation_time(restaurant_id, preparation_time)
    restaurant = Restaurant.find(restaurant_id)
    restaurant.preparation_time = preparation_time
    restaurant.save
    ActionCable.server.broadcast "restaurant_#{restaurant.id}",
      update: "preparation_time"
  end

  def meals
    restaurant = user.messenger_restaurant
    view.meals(restaurant)
  end

  private

  attr_reader :message, :user, :view
end
