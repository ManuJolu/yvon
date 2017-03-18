class BotYvon::MealsController
  def initialize(message, user)
    @view = BotYvon::MealsView.new(message, user)
  end

  def index(meal_category_id)
    meal_category = MealCategory.find(meal_category_id)
    next_meal_category = meal_category.lower_item
    meals = meal_category.meals.are_active.limit(9)
    view.index(meals.decorate, on_duty: meal_category.restaurant.on_duty?, meal_category: meal_category, next_meal_category: next_meal_category)
  end

  def get_option(meal, params = {})
    options = meal.options.are_active.limit(10)
    view.get_option(options, meal_id: meal.id, action: params[:action])
  end

  private

  attr_reader :view
end
