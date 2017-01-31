class RestaurantController
  def initialize
    @view = RestaurantView.new
  end

  def index(message, coordinates)
    restaurants = Restaurant.on_duty.where.not(latitude: nil, longitude: nil).near(coordinates, 0.6).limit(10)
    @view.index(message, coordinates, restaurants) if restaurants.present?
  end

  def menu(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu(postback, restaurant)
  end

  def menu_more(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu_more(postback, restaurant)
  end

  def check(user, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    user.current_order.restaurant == restaurant
  end

  def restaurant_mismatch(postback, user, params = {})
    wrong_restaurant = Restaurant.find(params[:restaurant_id])
    right_restaurant = user.current_order.restaurant
    @view.restaurant_mismatch(postback, wrong_restaurant.name)
    @view.menu(postback, right_restaurant)
  end

  def meal_restaurant_mismatch(postback, user, params = {})
    wrong_restaurant = Restaurant.find(params[:restaurant_id])
    right_restaurant = user.current_order.restaurant
    @view.meal_restaurant_mismatch(postback, wrong_restaurant.name)
    @view.menu(postback, right_restaurant)
  end
end
