class BotAline::NotificationsController
  def initialize
    @view = BotAline::NotificationsView.new
  end

  def notify_order(order)
    user_messenger_id = order.restaurant.messenger_user&.messenger_aline_id
    view.notify_order(order.decorate, user_messenger_id) if user_messenger_id
  end

  private

  attr_reader :view
end
