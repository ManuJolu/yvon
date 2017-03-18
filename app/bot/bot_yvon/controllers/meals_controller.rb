class BotYvon::MealsController
  def initialize(message, user)
    @view = BotYvon::MealsView.new(message, user)
  end

  def index(restaurant_id, meal_category_id)
    restaurant = Restaurant.find(restaurant_id)
    meal_category = MealCategory.find(meal_category_id)
    next_meal_category = meal_category.lower_item
    meals = restaurant.meals.are_active.where(meal_category: meal_category).limit(9)
    view.index(meals.decorate, on_duty: restaurant.on_duty?, meal_category: meal_category, next_meal_category: next_meal_category)
  end

  def get_option(meal, params = {})
    options = meal.options.are_active.limit(10)
    view.get_option(options, meal_id: meal.id, action: params[:action])
  end

  private

  attr_reader :view
end
