class BotAline::NotificationsController
  def initialize
    @view = BotAline::NotificationsView.new
  end

  def notify_order(order)
    user = order.restaurant.messenger_user
    UserLocaleContext.new(user).call { view.notify_order(order, user) } if user
  end

  def notify_duty(restaurant)
    user = restaurant.messenger_user
    duty = restaurant.on_duty ? 'OUVERT' : 'FERMÉ'
    UserLocaleContext.new(user).call { view.notify_duty(user, duty) } if user
  end

  def notify_preparation_time(restaurant)
    user = restaurant.messenger_user
    preparation_time = restaurant.preparation_time
    UserLocaleContext.new(user).call { view.notify_preparation_time(user, preparation_time) } if user
  end

  def logged_out(restaurant, user)
    logged_out_user = restaurant.messenger_user
    UserLocaleContext.new(user).call { view.logged_out(logged_out_user, restaurant, user) }
  end

  private

  attr_reader :view
end
