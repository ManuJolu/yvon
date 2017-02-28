class BotAline::Router
  def initialize(message)
    @user = BotAlineUserFinder.new(message).call

    @messages_controller = BotAline::MessagesController.new(message, @user)
    @restaurants_controller = BotAline::RestaurantsController.new(message, @user)
    @orders_controller = BotAline::OrdersController.new(message, @user)

    case message
    when Facebook::Messenger::Incoming::Message
      @message = message
      handle_message
    when Facebook::Messenger::Incoming::Postback
      @postback = message
      handle_postback
    end
  end

  private

  attr_reader :message, :postback, :user, :messages_controller,
    :restaurants_controller, :orders_controller

  def handle_message
    if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
      messages_controller.no_restaurant unless restaurants_controller.index
    end

    case message.text
    when /hello/i
      messages_controller.hello
    end
  end

  def handle_postback
    case postback.payload
    when 'start'
      messages_controller.hello
    when /\Arestaurant_(?<id>\d+)\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      restaurants_controller.login(restaurant_id)
    when 'orders'
      orders_controller.index
    when /\Aorder_(?<id>\d+)_(?<action>\D+)\z/
      order_id = $LAST_MATCH_INFO['id'].to_i
      action = $LAST_MATCH_INFO['action']
      orders_controller.update(order_id, action)
    end
  end
end
