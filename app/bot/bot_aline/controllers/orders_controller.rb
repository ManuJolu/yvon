class BotAline::OrdersController
  def initialize(message, user)
    @user = user
    @view = BotAline::OrdersView.new(message, user)
  end

  def index
    orders = user.messenger_restaurant.orders.at_today.to_deliver.reverse_order
    if orders.any?
      view.index(orders.decorate)
    else
      view.no_order(user.messenger_restaurant)
    end
  end

  def update(order_id, action)
    order = Order.find(order_id)
    case action
    when 'ready'
      order.ready_at ||= DateTime.now
      order.handled_at ||= order.ready_at
      if order.changed? && order.save
        BotYvon::NotificationsController.new.notify_ready(order) # if Rails.env.production?
        ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
          order_status: "ready"
      end
    when 'delivered'
      order.delivered_at ||= DateTime.now
      order.ready_at ||= order.delivered_at
      order.handled_at ||= order.ready_at
      if order.changed? && order.save
        BotYvon::NotificationsController.new.notify_delivered(order) # if Rails.env.production?
        ActionCable.server.broadcast "restaurant_orders_#{order.restaurant.id}",
          order_status: "delivered"
      end
    end
  end

  private

  attr_reader :user, :view
end
