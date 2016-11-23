class MealController
  def initialize
    @view = MealView.new
  end

  def menu(postback, params = {})
    if params[:restaurant_id].present?
      restaurant = Restaurant.find(params[:restaurant_id])
    elsif params[:meal_id].present?
      restaurant = Meal.find(params[:meal_id]).restaurant
    end
    @view.menu(postback, restaurant)
  end

  def menu_more(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu_more(postback, restaurant)
  end

  def index(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    meals = restaurant.meals.where(category: params[:category])
    @view.index(postback, meals)
  end
end
