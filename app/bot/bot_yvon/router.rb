class BotYvon::Router
  def initialize(message)
    @user = FindBotYvonUser.new(message).call

    @messages_controller = BotYvon::MessagesController.new(message, @user)
    @restaurants_controller = BotYvon::RestaurantsController.new(message, @user)
    @meals_controller = BotYvon::MealsController.new(message, @user)
    @orders_controller = BotYvon::OrdersController.new(message, @user)

    case message
    when Facebook::Messenger::Incoming::Message
      @message = message
      handle_message
    when Facebook::Messenger::Incoming::Postback
      @postback = message
      handle_postback
    when Facebook::Messenger::Incoming::Referral
      @referral = message
      handle_referral
    end
  end

  private

  attr_reader :message, :postback, :referral, :user, :messages_controller,
    :restaurants_controller, :meals_controller, :orders_controller

  def handle_message
    message.typing_on
    if message.attachments&.first.try(:[], 'type') == 'location'
      latitude = message.attachments.first['payload']['coordinates']['lat']
      longitude = message.attachments.first['payload']['coordinates']['long']
      if (restaurant = Restaurant.find_by(name: message.attachments.first['title'])) && (restaurant.distance_from([latitude, longitude]) < 0.1)
        orders_controller.create(latitude: latitude, longitude: longitude, restaurant: restaurant)
        restaurants_controller.show(restaurant.id)
      else
        orders_controller.create(latitude: latitude, longitude: longitude)
        messages_controller.no_restaurant unless restaurants_controller.index([latitude, longitude])
      end
    end

    case message.text
    when /hello/i, /bonjour/i, /bonsoir/i, /coucou/i, /salut/i, /wesh/i
      messages_controller.hello(keyword: $LAST_MATCH_INFO[0])
    when /help/i, /aide/i
      messages_controller.hello
    when /bordeaux/i
      order = orders_controller.create(latitude: '44.84308', longitude: '-0.0.57758')
      coordinates = [order.latitude, order.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
    when /harriet's/i, /harriet/i, /harriets/i
      restaurant = Restaurant.find(8)
      orders_controller.create(latitude: restaurant.latitude, longitude: restaurant.longitude, restaurant: restaurant)
      restaurants_controller.show(restaurant.id)
    else
      if user.current_order&.restaurant
        if user.current_order.table == 0
          case message.text
          when /(?<table_number>\d+)/
            orders_controller.set_table($LAST_MATCH_INFO['table_number'])
          when 'à emporter'
            orders_controller.takeaway
          end
        else
          case message.text
          when /\Acds\z/i
            orders_controller.pay_counter
          else
            case message.quick_reply
            when /\Ameal_(?<meal_id>\d+)_option_(?<option_id>\d+)\z/
              meal = Meal.find($LAST_MATCH_INFO['meal_id'])
              option = Option.find($LAST_MATCH_INFO['option_id'])
              if orders_controller.meal_match_user_restaurant?(meal)
                orders_controller.add_meal(meal, option)
                restaurants_controller.show(meal.restaurant.id)
              else
                restaurants_controller.meal_user_restaurant_mismatch(meal.restaurant.id)
              end
            when 'order_takeaway'
              orders_controller.takeaway
            end
          end
        end
      end
      message.typing_off
    end
  end

  def handle_postback
    case postback.payload
    when 'start'
      case postback&.referral&.ref
      when /\Arestaurant_(?<id>\d+)\z/
        sit_at_table($LAST_MATCH_INFO, start: true, restaurant_only: true)
        return
      when /\Arestaurant_(?<id>\d+)_table_(?<table>\d+)\z/
        sit_at_table($LAST_MATCH_INFO, start: true)
        return
      end
      messages_controller.hello(start: true)
      return
    when 'hello'
      messages_controller.hello
      return
    when 'map'
      coordinates = [user.current_order&.latitude, user.current_order&.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
      return
    when 'menu_update_card'
      orders_controller.menu_update_card
      return
    when 'share'
      messages_controller.share
      return
    when /\Arestaurant_(?<id>\d+)_table_(?<table>\d+)\z/
      sit_at_table($LAST_MATCH_INFO)
      return
    when /\Aorder_(?<id>\d+)_receipt\z/
      order_id = $LAST_MATCH_INFO['id']
      orders_controller.receipt(order_id)
      return
    end

    if user.current_order
      case postback.payload
      when /\Arestaurant_(?<id>\d+)\z/
        restaurant_id = $LAST_MATCH_INFO['id'].to_i
        orders_controller.update(restaurant_id: restaurant_id)
        restaurants_controller.show(restaurant_id)
      when /\Arestaurant_(?<id>\d+)_upvote\z/
        restaurant_id = $LAST_MATCH_INFO['id'].to_i
        restaurants_controller.upvote(restaurant_id)
      when /\Ameal_category_(?<meal_category_id>\w+)\z/
        meal_category_id = $LAST_MATCH_INFO['meal_category_id']
        if restaurants_controller.user_restaurant_match?(meal_category_id)
          meals_controller.index(meal_category_id)
        else
          restaurants_controller.user_restaurant_mismatch(meal_category_id)
        end
      when /\Ameal_(?<id>\d+)\z/
        meal = Meal.find($LAST_MATCH_INFO['id'])
        if orders_controller.meal_match_user_restaurant?(meal)
          if meal.options.are_active.any?
            meals_controller.get_option(meal)
          else
            orders_controller.add_meal(meal)
            restaurants_controller.show(meal.restaurant.id)
          end
        else
          restaurants_controller.meal_user_restaurant_mismatch(meal.restaurant.id)
        end
      when 'change_table'
        orders_controller.ask_table
      when /\Arm_ordered_meal_(?<id>\d+)\z/
        ordered_meal_id = $LAST_MATCH_INFO['id']
        orders_controller.remove_ordered_meal(ordered_meal_id)
      when 'menu'
        if user.current_order&.restaurant
          restaurants_controller.show(user.current_order.restaurant.id)
        else
          messages_controller.no_restaurant_selected
        end
      when 'cart'
        if user.current_order&.restaurant
          orders_controller.cart
        else
          messages_controller.no_restaurant_selected
        end
      when 'check_card'
        orders_controller.check_card
      when 'update_card'
        orders_controller.update_card
      when 'check_counter'
        orders_controller.check_counter
      when 'demo'
        orders_controller.demo
      end
    else
      messages_controller.no_current_order
    end
  end

  def handle_referral
    case referral.ref
    when /\Arestaurant_(?<id>\d+)\z/
      sit_at_table($LAST_MATCH_INFO, restaurant_only: true)
      return
    when /\Arestaurant_(?<id>\d+)_table_(?<table>\d+)\z/
      sit_at_table($LAST_MATCH_INFO)
    end
  end

  private

  def sit_at_table(last_match_info, params = {})
    restaurant_id = last_match_info['id'].to_i
    if params[:restaurant_only]
      messages_controller.hello(start: params[:start], restaurant_id: restaurant_id)
    else
      table = last_match_info['table'].to_i
      messages_controller.hello(start: params[:start], table: table)
    end
    orders_controller.create(restaurant_id: restaurant_id, table: table)
    restaurants_controller.show(restaurant_id)
  end
end
