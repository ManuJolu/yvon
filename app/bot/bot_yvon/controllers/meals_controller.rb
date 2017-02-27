class BotYvon::MealsController
  def initialize
    @view = BotYvon::MealsView.new
  end

  def index(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    meal_category = MealCategory.find(params[:meal_category_id])
    next_meal_category = meal_category.lower_item
    meals = restaurant.meals.is_active.where(meal_category: meal_category).limit(9)
    @view.index(postback, meals.decorate, order_acceptance: restaurant.order_acceptance?, current_meal_category: meal_category, next_meal_category: next_meal_category)
  end

  def get_option(postback, meal, params = {})
    options = meal.options
    @view.get_option(postback, options, meal_id: meal.id, action: params[:action])
  end
end
