class BotYvon::OrdersController
  def initialize(message, user)
    @user = user
    @message = message
    @view = BotYvon::OrdersView.new(message, user)
  end

  def create(params = {})
    if params[:table]
      restaurant = Restaurant.find(params[:restaurant_id])
      order = user.orders.create({
          located_at: Time.now,
          latitude: restaurant.latitude,
          longitude: restaurant.longitude,
          restaurant: restaurant,
          table: params[:table]
        })
    else
      order = user.orders.create({
          located_at: Time.now,
          latitude: params[:latitude],
          longitude: params[:longitude],
          restaurant: params[:restaurant]
        })
    end
  end

  def update(params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    unless user.current_order.restaurant == restaurant
      user.current_order.ordered_meals.destroy_all
      user.current_order.update(restaurant: restaurant, table: nil)
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
      order.update(table: 0) if order.table.nil?
      view.cart(order)
    else
      view.no_meals
    end
  end

  def ask_table
    user.current_order.update(table: 0)
    view.ask_table
  end

  def remove_ordered_meal(ordered_meal_id)
    OrderedMeal.find(ordered_meal_id).destroy
    cart
  end

  def set_table(table_number)
    user.current_order.update(table: table_number)
    view.ask_payment_method(user.current_order)
  end

  def takeaway
    user.current_order.update(table: -1)
    view.ask_payment_method(user.current_order)
  end

  def check_card
    if user.stripe_customer_id
      pay_card
    else
      update_card
    end
  end

  def update_card
    view.update_card
  end

  def pay_card
    if user.current_order.ordered_meals.present?
      order = user.current_order
      if order.restaurant.on_duty?
        order.sent_at = Time.now
        order.save # fastest possible remove of current_order

        begin
          charge = Stripe::Charge.create(
            customer:     user.stripe_customer_id,
            description:  "restaurant_#{order.restaurant.id}_order_#{order.id} - #{order.restaurant.name}",
            amount:       order.price_cents,
            currency:     order.price.currency
          )
          order.update(
            payment: charge.to_json,
            payment_method: :credit_card,
            preparation_time: order.restaurant.preparation_time,
          )
          BotAline::NotificationsController.new.notify_order(order)
          ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
            order_status: "sent"
          view.confirm(order)
        rescue Stripe::StripeError => e
          order.sent_at = nil
          order.save
          view.stripe_error(e.message)
        end
      else
        view.restaurant_closed(order.restaurant)
      end
    else
      view.no_meals
    end
  end

  def check_counter
    if user.stripe_customer_id
      pay_counter
    else
      update_card_counter
    end
  end

  def update_card_counter
    view.update_card_counter
  end

  def pay_counter # does not take into account if you have no table...
    if user.current_order.ordered_meals.present?
      order = user.current_order
      if order.restaurant.on_duty?
        order.sent_at = Time.now
        order.save # fastest possible remove of current_order
        order.preparation_time = order.restaurant.preparation_time
        order.counter!
        order.save
        BotAline::NotificationsController.new.notify_order(order)
        ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
          order_status: "sent"
        view.confirm(order)
      else
        view.restaurant_closed(order.restaurant)
      end
    else
      view.no_meals
    end
  end

  def demo
    if user.current_order.ordered_meals.present?
      order = user.current_order
      if order.restaurant.on_duty?
        order.preparation_time = order.restaurant.preparation_time
        order.restaurant = Restaurant.find(1)
        order.sent_at = Time.now
        order.demo!
        order.save
        BotAline::NotificationsController.new.notify_order(order)
        ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
          order_status: "sent"
        view.confirm(order)
      else
        view.restaurant_closed(order.restaurant)
      end
    else
      view.no_meals
    end
  end

  def receipt(order_id)
    order = Order.find(order_id)
    view.receipt(order)
  end

  def menu_update_card
    view.menu_update_card
  end

  private

  attr_reader :user, :message, :view
end
