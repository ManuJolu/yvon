class BotYvon::OrdersController
  def initialize(message, user)
    @user = user
    @message = message
    @view = BotYvon::OrdersView.new(message, user)
  end

  def create(params = {})
    order = user.orders.create({
        located_at: Time.now,
        latitude: params[:latitude] || message.attachments[0]['payload']['coordinates']['lat'],
        longitude: params[:longitude] || message.attachments[0]['payload']['coordinates']['long']
      })
  end

  def update(params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    unless user.current_order.restaurant == restaurant
      user.current_order.ordered_meals.destroy_all
      user.current_order.update(restaurant: restaurant)
    end
  end

  def meal_match_user_restaurant?(meal)
    user.current_order&.restaurant == meal.restaurant
  end

  def add_meal(meal, option = nil)
    current_ordered_meal = user.current_order.ordered_meals.find_by(meal: meal, option: option)
    if current_ordered_meal
      current_ordered_meal.quantity += 1
    else
      current_ordered_meal = user.current_order.ordered_meals.new(meal: meal, option: option)
    end
    current_ordered_meal.save
  end

  def cart
    if user.current_order&.meals.present?
      order = user.current_order
      order.create_elements
      order.reload
      view.cart(order.decorate)
    else
      view.no_meals
    end
  end

  def confirm
    if user.current_order.meals.present?
      order = user.current_order
      if order.restaurant.on_duty?
        order.preparation_time = order.restaurant.preparation_time
        order.sent_at = Time.now
        order.save
        BotAline::NotificationsController.new.notify_order(order)
        ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
          order_status: "sent"
        view.confirm(order.decorate, sent_at: order.sent_at.to_i, program: 'beta')
      else
        view.restaurant_closed(order.restaurant)
      end
    else
      view.no_meals
    end
  end

  def demo
    if user.current_order.meals.present?
      order = user.current_order
      if order.restaurant.on_duty?
        order.preparation_time = order.restaurant.preparation_time
        order.sent_at = Time.now
        order.restaurant = Restaurant.find(1)
        order.save
        BotAline::NotificationsController.new.notify_order(order)
        ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
          order_status: "sent"
        view.confirm(order.decorate, sent_at: Time.now.to_i, program: 'demo')
      else
        view.restaurant_closed(order.restaurant)
      end
    else
      view.no_meals
    end
  end

  private

  attr_reader :user, :message, :view
end
