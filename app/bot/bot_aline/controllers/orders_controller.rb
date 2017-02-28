class BotAline::OrdersController
  def initialize(message, user)
    @view = BotAline::OrdersView.new(message, user)
  end

  def index
    orders = user.restaurant
  end

  def update(order_id, action)
    order = Order.find(order_id)
    case action
    when 'ready'
      order.ready_at ||= DateTime.now
      order.handled_at ||= order.ready_at
      if order.changed? && order.save
        BotYvon::OrdersView.new.notify_ready(order) # if Rails.env.production?
        ActionCable.server.broadcast "restaurant_#{order.restaurant.id}",
          order_status: "ready"
      end
    when 'delivered'
      order.delivered_at ||= DateTime.now
      order.ready_at ||= order.delivered_at
      order.handled_at ||= order.ready_at
      if order.changed? && order.save
        BotYvon::OrdersView.new.notify_delivered(order) # if Rails.env.production?
        ActionCable.server.broadcast "restaurant_#{order.restaurant.id}",
          order_status: "ready"
      end
    end
  end

  private

  attr_reader :view
end
