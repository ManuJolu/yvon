class BotYvon::NotificationsView
  def notify_ready(order, user)
    Bot.deliver({
      recipient: {
        id: user.messenger_id
      },
      message: {
        text: I18n.t('bot.order.notify_ready', user_first_name: user.first_name,restaurant_name: order.restaurant.name)
      }},
      access_token: ENV['YVON_ACCESS_TOKEN']
    )
  end

  def notify_delivered(order, user)
    Bot.deliver({
      recipient: {
        id: user.messenger_id
      },
      message: {
        text: I18n.t('bot.order.notify_delivered', user_first_name: user.first_name,restaurant_name: order.restaurant.name)
      }},
      access_token: ENV['YVON_ACCESS_TOKEN']
    )
  end
end
