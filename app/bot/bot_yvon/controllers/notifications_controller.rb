class BotYvon::NotificationsController
  def initialize
    @view = BotYvon::NotificationsView.new
  end

  def notify_ready(order)
    user = order.user
    view.notify_ready(order, user) if user && order.table.nil?
  end

  def notify_delivered(order)
    user = order.user
    view.notify_delivered(order, user) if user && order.table.nil?
  end

  private

  attr_reader :view
end
