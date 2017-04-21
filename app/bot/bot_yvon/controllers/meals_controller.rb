class BotYvon::MealsController
  def initialize(message, user)
    @view = BotYvon::MealsView.new(message, user)
  end

  def index(meal_category_id)
    meal_category = MealCategory.includes(:restaurant, :photo_files, { active_meals: [ :options, :photo_files] }).find(meal_category_id)
    view.index(meal_category.active_meals.decorate, on_duty: (meal_category.restaurant.active? && meal_category.restaurant.on_duty?), meal_category: meal_category)
  end

  def get_option(meal, params = {})
    options = meal.options.are_active.limit(10)
    view.get_option(options.decorate, meal: meal)
  end

  private

  attr_reader :view
end
