class RestaurantController
  def initialize
    @view = RestaurantView.new
  end

  def index(message, coordinates)
    restaurants = Restaurant.on_duty.where.not(latitude: nil, longitude: nil).near(coordinates, 0.6).limit(10)
    @view.index(message, coordinates, restaurants)
  end

  def menu(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu(postback, restaurant)
  end

  def menu_more(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu_more(postback, restaurant)
  end

  def not_my_meal(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.not_my_meal(postback, restaurant.name)
    @view.menu(postback, restaurant)
  end

  def no_restaurant(postback)
    @view.no_restaurant(postback)
  end
end
