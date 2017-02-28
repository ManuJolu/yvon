class BotAline::NotificationsController
  def initialize
    @view = BotAline::NotificationsView.new
  end

  def notify_order(order)
    user = order.restaurant.messenger_user
    view.notify_order(order.decorate, user) if user
  end

  def logged_out(restaurant, user)
    logged_out_user = restaurant.messenger_user
    view.logged_out(logged_out_user, restaurant, user)
  end

  private

  attr_reader :view
end
