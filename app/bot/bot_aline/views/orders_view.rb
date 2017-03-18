class BotAline::OrdersView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def index(orders)
    orders.each do |order|
      order_array = ["Commande de #{order.user.decorate.name} :"]
      order_array << order.ordered_meals.by_meal_category.decorate.map { |ordered_meal| ordered_meal }
      case order.state
      when 'paid'
        order_array << "Payé : #{order.decorate.price}"
      when 'password_confirmed'
        order_array << "Paiement au comptoir : #{order.decorate.price}"
      when 'demo'
        order_array << "Démo : #{order.decorate.price}"
      end

      buttons = []

      if order.ready_at.nil?
        order_array << "Prêt : max #{order.decorate.ready_at_limit}"
        buttons << { type: 'postback', title: 'Prêt', payload: "order_#{order.id}_ready" }
      else
        order_array << "Prêt à #{order.decorate.ready_at} (max #{order.decorate.ready_at_limit})"
      end

      buttons << { type: 'postback', title: 'Livré', payload: "order_#{order.id}_delivered" }

      message.reply(
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: order_array.join("\n"),
            buttons: buttons
          }
        }
      )
    end
  end

  def no_order(restaurant)
    text = ["#{restaurant.name}"]
    text << "Il n'y a pas de commandes en cours."
    duty = (restaurant.on_duty? ? "OUVERT" : "FERMÉ")
    text << "Le service est #{duty}."
    text << "Le temps de préparation est de #{restaurant.preparation_time} min."
    message.reply(
      text: text.join("\n")
    )
  end

  private

  attr_reader :message, :user
end
