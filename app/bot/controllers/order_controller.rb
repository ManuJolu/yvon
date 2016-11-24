class OrderController
  def initialize
    @view = OrderView.new
  end

  def add_meal(user, meal_id)
    (user.session['order']['meals'] ||= []) << { meal_id: meal_id}
    user.save
  end

  def cart(user)
    order = user.orders.new
    order.restaurant = Restaurant.find(user.session['order']['restaurant_id'])
    user.session['order']['meals'].each do |meal|
      ordered_meal = order.ordered_meals.new
      ordered_meal.meal = Meal.find(meal['meal_id'])
    end
    order.save

    @view.cart(user)
  end
end
