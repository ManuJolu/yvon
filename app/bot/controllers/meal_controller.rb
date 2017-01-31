class MealController
  def initialize
    @view = MealView.new
  end

  def index(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    meals = restaurant.meals.is_active.where(category: params[:category]).limit(9)
    next_category = Meal.categories.key(Meal.categories[params[:category]] + 1)
    @view.index(postback, meals.decorate, current_category: params[:category], next_category: next_category)
  end

  def get_option(postback, meal, params = {})
    options = meal.options
    @view.get_option(postback, options, meal_id: meal.id, action: params[:action])
  end
end
