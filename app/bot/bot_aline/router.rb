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

    case message.quick_reply
    when /\Arestaurant_(?<id>\d+)_pass_(?<attempt>\d{2})\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      attempt = $LAST_MATCH_INFO['attempt']
      restaurants_controller.verify_login(restaurant_id, step: attempt.size, attempt: attempt)
    when /\Arestaurant_(?<id>\d+)_pass_(?<attempt>\d+)\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      attempt = $LAST_MATCH_INFO['attempt']
      restaurants_controller.pass(restaurant_id, step: attempt.size, attempt: attempt)
    when /\Arestaurant_(?<id>\d+)_preparation_time_(?<preparation_time>\d+)\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      preparation_time = $LAST_MATCH_INFO['preparation_time'].to_i
      restaurants_controller.update_preparation_time(restaurant_id, preparation_time)
    end

  end

  def handle_postback
    case postback.payload
    when 'start'
      messages_controller.hello
    when /\Arestaurant_(?<id>\d+)\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      restaurants_controller.pass(restaurant_id, step: 0, attempt: "")
    end

    if user.messenger_restaurant
      case postback.payload
      when 'duty'
        restaurants_controller.duty
      when /\Arestaurant_(?<id>\d+)_duty_(?<duty>\D+)\z/
        restaurant_id = $LAST_MATCH_INFO['id'].to_i
        duty = $LAST_MATCH_INFO['duty']
        restaurants_controller.update_duty(restaurant_id, duty)
      when 'preparation_time'
        restaurants_controller.preparation_time
      when 'orders'
        #verify that user has messenger_restaurant
        orders_controller.index
      when /\Aorder_(?<id>\d+)_(?<action>\D+)\z/
        order_id = $LAST_MATCH_INFO['id'].to_i
        action = $LAST_MATCH_INFO['action']
        orders_controller.update(order_id, action)
      end
    else
      messages_controller.no_restaurant_connected
    end
  end
end
