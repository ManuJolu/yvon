class BotYvon::RestaurantsController
  def initialize(message, user)
    @user = user
    @view = BotYvon::RestaurantsView.new(message, user)
  end

  def index(coordinates)
    restaurants = Restaurant.active.by_duty.where.not(latitude: nil, longitude: nil).near(coordinates, 1).limit(10)
    view.index(coordinates, restaurants) if restaurants.present?
  end

  def show(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    view.show(restaurant, ordered_meals?: user.current_order.ordered_meals.present?)
  end

  def menus(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    view.menus(restaurant)
  end

  def user_restaurant_match?(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    user.current_order.restaurant == restaurant
  end

  def user_restaurant_mismatch(restaurant_id)
    wrong_restaurant = Restaurant.find(restaurant_id)
    right_restaurant = user.current_order.restaurant
    view.user_restaurant_mismatch(wrong_restaurant.name)
    view.menu(right_restaurant, ordered_meals: user.current_order.ordered_meals.present?)
  end

  def meal_user_restaurant_mismatch(restaurant_id)
    wrong_restaurant = Restaurant.find(restaurant_id)
    right_restaurant = user.current_order.restaurant
    view.meal_user_restaurant_mismatch(wrong_restaurant.name)
    view.menu(right_restaurant, ordered_meals: user.current_order.ordered_meals.present?)
  end

  private

  attr_reader :user, :view
end
