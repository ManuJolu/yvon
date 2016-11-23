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
    meals = restaurant.meals.where(category: params[:category])
    next_category = Meal.categories.key(Meal.categories[params[:category]] + 1)
    @view.index(postback, meals, next_category: next_category)
  end
end
