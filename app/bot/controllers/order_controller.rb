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
    if (user.session['order'] ||= {})['meals'].present?
      order = user.orders.new
      order.restaurant = Restaurant.find(user.session['order']['restaurant_id'])
      order.located_at = user.session['located_at'].to_datetime
      order.latitude = user.session['latitude'].to_f
      order.longitude = user.session['longitude'].to_f
      user.session['order']['meals'].each do |meal_id, quantity|
        ordered_meal = order.ordered_meals.new
        ordered_meal.meal = Meal.find(meal_id.to_i)
        ordered_meal.quantity = quantity.to_i
      end
      order.ordered_meals = order.ordered_meals.sort do |x, y|
        if (x.meal.category <=> y.meal.category) != 0
          x.meal.category <=> y.meal.category
        else
          x.meal.name.downcase <=> y.meal.name.downcase
        end
      end
      order.paid_at = Time.now

      if order.save
        user.session['order']['meals'] = {}
        user.save
      else
      end
      @view.cart(postback, order.decorate)
    else
      @view.no_meals(postback)
    end
  end
end
