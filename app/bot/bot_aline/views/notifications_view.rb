class BotAline::NotificationsView
  def notify_order(order, user)
    order_array = ["Commande de #{order.user.decorate.name} :"]
    order_array << order.ordered_meals.by_meal_category.decorate.map { |ordered_meal| ordered_meal }
    case order.payment_method
    when 'credit_card'
      order_array << "Payé : #{order.decorate.price}"
    when 'counter'
      order_array << "Paiement au comptoir : #{order.decorate.price}"
    when 'demo'
      order_array << "Démo : #{order.decorate.price}"
    end
    if order.table > 0
      order_array << "Table #{order.table}"
    else
      order_array << "A emporter"
    end
    order_array << "Prêt : max #{order.decorate.ready_at_limit}"

    Bot.deliver(
      {
        recipient: {
          id: user.messenger_aline_id
        },
        message: {
          attachment: {
            type: 'template',
            payload: {
              template_type: 'button',
              text: order_array.join("\n"),
              buttons: [
                { type: 'postback', title: 'Prêt', payload: "order_#{order.id}_ready" },
                { type: 'postback', title: 'Livré', payload: "order_#{order.id}_delivered" }
              ]
            }
          }
        }
      },
      access_token: ENV['ALINE_ACCESS_TOKEN']
    ) rescue nil
  end

  def notify_duty(user, duty)
    Bot.deliver(
      {
        recipient: {
          id: user.messenger_aline_id
        },
        message: {
          text: "Le service a été modifié : #{duty}"
        }
      },
      access_token: ENV['ALINE_ACCESS_TOKEN']
    ) rescue nil
  end

  def notify_preparation_time(user, preparation_time)
    Bot.deliver(
      {
        recipient: {
          id: user.messenger_aline_id
        },
        message: {
          text: "Le temps de préparation à été modifié : #{preparation_time} min"
        }
      },
      access_token: ENV['ALINE_ACCESS_TOKEN']
    ) rescue nil
  end

  def logged_out(logged_out_user, restaurant, user)
    Bot.deliver(
      {
        recipient: {
          id: logged_out_user.messenger_aline_id
        },
        message: {
          text: "#{logged_out_user.first_name}, tu as été déconnecté de #{restaurant.name} par #{user.decorate.name}"
        }
      },
      access_token: ENV['ALINE_ACCESS_TOKEN']
    ) rescue nil
  end
end
