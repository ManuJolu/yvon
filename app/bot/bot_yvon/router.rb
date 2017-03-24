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
      message.type
      order = orders_controller.create
      coordinates = [order.latitude, order.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
    end

    case message.text
    when /hello/i, /hi/i, /bonjour/i, /bonsoir/i, /coucou/i, /salut/i, /help/i, /aide/i
      messages_controller.hello
    when /bordeaux/i
      message.type
      order = orders_controller.create(latitude: '44.840715', longitude: '-0.5721098')
      coordinates = [order.latitude, order.longitude]
      messages_controller.no_restaurant unless restaurants_controller.index(coordinates)
    else
      if user.current_order&.restaurant
        case message.text
        when /\Acds\z/i
          orders_controller.pay_counter
        else
          case message.quick_reply
          when /\Ameal_(?<meal_id>\d+)_option_(?<option_id>\d+)_(?<action>\D+)\z/
            message.type
            meal = Meal.find($LAST_MATCH_INFO['meal_id'])
            option = Option.find($LAST_MATCH_INFO['option_id'])
            action = $LAST_MATCH_INFO['action']
            if orders_controller.meal_match_user_restaurant?(meal)
              orders_controller.add_meal(meal, option)
              case action
              when 'menu'
                restaurants_controller.show(meal.restaurant.id)
              when 'next'
                meals_controller.index(meal.meal_category.lower_item.id)
              end
            else
              restaurants_controller.meal_user_restaurant_mismatch(meal.restaurant.id)
            end
          # else
          #   messages_controller.no_comprendo if message.quick_reply.nil?
          end
        end
      # else
      #   # message.type_off
      #   messages_controller.else if user.current_order.nil?
      end
    end
  end

  def handle_postback
    case postback.payload
    when 'start'
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
      when /\Arestaurant_(?<id>\d+)_menus\z/
        restaurant_id = $LAST_MATCH_INFO['id'].to_i
        restaurants_controller.menus(restaurant_id)
      when /\Ameal_category_(?<meal_category_id>\w+)\z/
        meal_category_id = $LAST_MATCH_INFO['meal_category_id']
        if restaurants_controller.user_restaurant_match?(meal_category_id)
          meals_controller.index(meal_category_id)
        else
          restaurants_controller.user_restaurant_mismatch(meal_category_id)
        end
      when /\Ameal_(?<id>\d+)_(?<action>\D+)\z/
        meal = Meal.find($LAST_MATCH_INFO['id'])
        action = $LAST_MATCH_INFO['action']
        if orders_controller.meal_match_user_restaurant?(meal)
          if meal.options.are_active.any?
            meals_controller.get_option(meal, action: action)
          else
            orders_controller.add_meal(meal)
            case action
            when 'menu'
              restaurants_controller.show(meal.restaurant.id)
            when 'next'
              meals_controller.index(meal.meal_category.lower_item.id)
            end
          end
        else
          restaurants_controller.meal_user_restaurant_mismatch(meal.restaurant.id)
        end
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
end
