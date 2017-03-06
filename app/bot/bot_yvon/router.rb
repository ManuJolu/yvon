class BotYvon::Router
  def initialize(message)
    @user = BotUserFinder.new(message).call

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
    end
  end

  private

  attr_reader :message, :postback, :user, :messages_controller,
    :restaurants_controller, :meals_controller, :orders_controller

  def handle_message
    if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
      order = orders_controller.create
      coordinates = [order.latitude, order.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
    end

    case message.text
    when /hello/i
      messages_controller.hello
    when /bordeaux/i
      order = orders_controller.create(latitude: '44.8413522', longitude: '-0.5810738')
      coordinates = [order.latitude, order.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
    else
      if user.current_order&.restaurant
        case message.text
        when /cdsbeta/i
          orders_controller.confirm
        when /talisbeta/i
          orders_controller.confirm
        end

        case message.quick_reply
        when /demo/i
          orders_controller.demo
        when /\Ameal_(?<meal_id>\d+)_option_(?<option_id>\d+)_(?<action>\D+)\z/
          meal = Meal.find($LAST_MATCH_INFO['meal_id'])
          option = Option.find($LAST_MATCH_INFO['option_id'])
          action = $LAST_MATCH_INFO['action']
          if orders_controller.meal_match_user_restaurant?(meal)
            orders_controller.add_meal(meal, option)
            case action
            when 'menu'
              restaurants_controller.menu(meal.restaurant.id)
            end
          else
            restaurants_controller.meal_user_restaurant_mismatch(meal.restaurant.id)
          end
        end
      else
        messages_controller.else if user.current_order.nil?
      end
    end
  end

  def handle_postback
    case postback.payload
    when 'start'
      messages_controller.hello
    when 'share'
      messages_controller.share
    when 'map'
      coordinates = [user.current_order&.latitude, user.current_order&.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
    end

    if user.current_order
      case postback.payload
      when /\Arestaurant_(?<id>\d+)\z/
        restaurant_id = $LAST_MATCH_INFO['id'].to_i
        orders_controller.update(restaurant_id: restaurant_id)
        restaurants_controller.menu(restaurant_id)
      when /\Arestaurant_(?<id>\d+)_menus\z/
        restaurant_id = $LAST_MATCH_INFO['id'].to_i
        restaurants_controller.display_menus(restaurant_id)
      when /\Arestaurant_(?<restaurant_id>\d+)_category_(?<meal_category_id>\w+)\z/
        restaurant_id = $LAST_MATCH_INFO['restaurant_id'].to_i
        meal_category_id = $LAST_MATCH_INFO['meal_category_id']
        if restaurants_controller.user_restaurant_match?(restaurant_id)
          meals_controller.index(restaurant_id, meal_category_id)
        else
          restaurants_controller.user_restaurant_mismatch(restaurant_id)
        end
      when /\Ameal_(?<id>\d+)_(?<action>\D+)\z/
        meal = Meal.find($LAST_MATCH_INFO['id'])
        action = $LAST_MATCH_INFO['action']
        if orders_controller.meal_match_user_restaurant?(meal)
          if meal.options.is_active.any?
            meals_controller.get_option(meal, action: action)
          else
            orders_controller.add_meal(meal)
            case action
            when 'menu'
              restaurants_controller.menu(meal.restaurant.id)
            end
          end
        else
          restaurants_controller.meal_user_restaurant_mismatch(meal.restaurant.id)
        end
      when 'menu'
        if user.current_order&.restaurant
          restaurants_controller.menu(user.current_order.restaurant.id)
        else
          messages_controller.no_restaurant_selected
        end
      when 'cart'
        if user.current_order&.restaurant
          orders_controller.cart
        else
          messages_controller.no_restaurant_selected
        end
      end
    end
  end
end
