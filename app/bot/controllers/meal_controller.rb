class MealController
  def initialize
    @view = MealView.new
  end

  def menu(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu(postback, restaurant)
  end

  def menu_more(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu_more(postback, restaurant)
  end

  def index(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    meals = restaurant.meals.where(category: params[:category]).limit(9)
    next_category = Meal.categories.key(Meal.categories[params[:category]] + 1)
    @view.index(postback, meals.decorate, current_category: params[:category], next_category: next_category)
  end

  def no_restaurant(postback)
    @view.no_restaurant(postback)
  end
end
