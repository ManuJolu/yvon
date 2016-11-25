class OrderController
  def initialize
    @view = OrderView.new
  end

  def add_meal(user, meal_id)
    if (user.session['order']['meals'] ||= {})[meal_id].present?
      (user.session['order']['meals'] ||= {})[meal_id] += 1
    else
      (user.session['order']['meals'] ||= {})[meal_id] = 1
    end
    user.save
  end

  def cart(postback, user)
    order = user.orders.new
    order.restaurant = Restaurant.find(user.session['order']['restaurant_id'])
    user.session['order']['meals'].each do |meal_id, quantity|
      ordered_meal = order.ordered_meals.new
      ordered_meal.meal = Meal.find(meal_id.to_i)
      ordered_meal.quantity = quantity.to_i
    end
    order.paid_at = Time.now

    if order.save
      user.session['order']['meals'] = {}
      user.save
    else
    end
    @view.cart(postback, order)
  end
end
