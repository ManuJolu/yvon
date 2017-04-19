class BotYvon::MealsController
  def initialize(message, user)
    @view = BotYvon::MealsView.new(message, user)
  end

  def index(meal_category_id)
    meal_category = MealCategory.find(meal_category_id)
    meals = meal_category.meals.are_active.limit(9)
    view.index(meals.decorate, on_duty: (meal_category.restaurant.active? && meal_category.restaurant.on_duty?), meal_category: meal_category)
  end

  def get_option(meal, params = {})
    options = meal.options.are_active.limit(10)
    view.get_option(options, meal_id: meal.id)
  end

  private

  attr_reader :view
end
