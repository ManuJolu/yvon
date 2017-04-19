class BotYvon::NotificationsController
  def initialize
    @view = BotYvon::NotificationsView.new
  end

  def notify_ready(order)
    user = order.user
    view.notify_ready(order, user) if user && order.table < 0
  end

  def notify_delivered(order)
    user = order.user
    if user
      if order.table > 0
        view.notify_served(order, user)
      else
        view.notify_delivered(order, user)
      end
    end
  end

  private

  attr_reader :view
end
