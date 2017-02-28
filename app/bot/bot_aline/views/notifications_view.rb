class BotAline::NotificationsView
  def notify_order(order, user_messenger_id)
    order_array = ["Commande de #{order.user.name} :"]
    order_array << order.ordered_meals.map { |ordered_meal| ordered_meal }
    order_array << "Prix : #{order.price} - non payé"
    order_array << "Prêt avant #{order.ready_at_limit}."

    Bot.deliver(
      {
        recipient: {
          id: user_messenger_id
        },
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: order_array.join("\n"),
              buttons: [
                { type: 'postback', title: 'OK', payload: 'handled' },
                { type: 'postback', title: 'Prêt', payload: 'ready' },
                { type: 'postback', title: 'Livré', payload: 'delivered' }
              ]
            }
          }
        }
      },
      access_token: ENV['ALINE_ACCESS_TOKEN']
    )
  end
end
