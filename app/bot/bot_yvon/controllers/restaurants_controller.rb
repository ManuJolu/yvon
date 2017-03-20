class BotYvon::RestaurantsController
  def initialize(message, user)
    @user = user
    @view = BotYvon::RestaurantsView.new(message, user)
  end

  def index(coordinates)
    restaurants = Restaurant.are_votable_plus.by_duty.where.not(latitude: nil, longitude: nil).near(coordinates, 0.5).limit(10)
    view.index(coordinates, restaurants) if restaurants.present?
  end

  def show(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    view.show(restaurant, ordered_meals?: user.current_order.ordered_meals.present?)
  end

  def upvote(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    restaurant.upvote_from user
    view.upvote(restaurant)
  end

  def menus(restaurant_id)
    restaurant = Restaurant.find(restaurant_id)
    view.menus(restaurant)
  end

  def user_restaurant_match?(meal_category_id)
    meal_category = MealCategory.find(meal_category_id)
    user.current_order.restaurant == meal_category.restaurant
  end

  def user_restaurant_mismatch(meal_category_id)
    meal_category = MealCategory.find(meal_category_id)
    wrong_restaurant = meal_category.restaurant
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
