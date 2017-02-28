class BotYvon::Router
  def initialize(message)
    @messages_controller = BotYvon::MessagesController.new
    @restaurants_controller = BotYvon::RestaurantsController.new
    @meals_controller = BotYvon::MealsController.new
    @orders_controller = BotYvon::OrdersController.new

    @user = BotUserFinder.new(message).call
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
      new_order = orders_controller.create(message, user)
      coordinates = [new_order.latitude, new_order.longitude]
      messages_controller.no_restaurant(message) unless restaurants_controller.index(message, coordinates)
    end

    case message.text
    when /hello/i
      messages_controller.hello(message, user)
    when /bordeaux/i
      new_order = orders_controller.create(message, user, lat: '44.8413522', lng: '-0.5810738')
      coordinates = [new_order.latitude, new_order.longitude]
      messages_controller.no_restaurant(message) unless restaurants_controller.index(message, coordinates)
    when /cdsbeta/i
      if user.current_order&.restaurant
        orders_controller.confirm(message, user)
      else
        messages_controller.no_restaurant_selected(message)
      end
    when /talisbeta/i
      if user.current_order&.restaurant
        orders_controller.confirm(message, user)
      else
        messages_controller.no_restaurant_selected(message)
      end
    # else
    #   if message.text
    #     messages_controller.else(message)
    #   end
    end

    case message.quick_reply
    when /demo/i
      if user.current_order&.restaurant
        orders_controller.demo(message, user)
      else
        messages_controller.no_restaurant_selected(message)
      end
    end
  end

  def handle_postback
    case postback.payload
    when 'start'
      messages_controller.hello(postback, user)
    when /\Arestaurant_(?<id>\d+)_page_(?<page>\d+)\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      page = $LAST_MATCH_INFO['page'].to_i
      orders_controller.update(postback, user, restaurant_id: restaurant_id)
      restaurants_controller.menu(postback, user, restaurant_id: restaurant_id, page: page)
    when /\Arestaurant_(?<restaurant_id>\d+)_category_(?<meal_category_id>\w+)\z/
      restaurant_id = $LAST_MATCH_INFO['restaurant_id'].to_i
      meal_category_id = $LAST_MATCH_INFO['meal_category_id']
      if restaurants_controller.check(user, restaurant_id: restaurant_id)
        meals_controller.index(postback, restaurant_id: restaurant_id, meal_category_id: meal_category_id)
      else
        restaurants_controller.restaurant_mismatch(postback, user, restaurant_id: restaurant_id)
      end
    when /\Ameal_(?<id>\d+)_(?<action>\D+)\z/
      meal = Meal.find($LAST_MATCH_INFO['id'])
      action = $LAST_MATCH_INFO['action']
      if orders_controller.meal_match_restaurant(user, meal)
        if meal.options.any?
          meals_controller.get_option(postback, meal, action: action)
        else
          orders_controller.add_meal(user, meal)
          case action
          when 'menu'
            restaurants_controller.menu(postback, user, restaurant_id: meal.restaurant.id)
          when 'next'
            next_category = meal.meal_category.lower_item
            meals_controller.index(postback, restaurant_id: meal.restaurant.id, meal_category_id: next_category.id)
          when 'cart'
            orders_controller.cart(postback, user)
          end
        end
      else
        restaurants_controller.meal_restaurant_mismatch(postback, user, restaurant_id: meal.restaurant.id)
      end
    when /\Ameal_(?<meal_id>\d+)_option_(?<option_id>\d+)_(?<action>\D+)\z/
      meal = Meal.find($LAST_MATCH_INFO['meal_id'])
      option = Option.find($LAST_MATCH_INFO['option_id'])
      action = $LAST_MATCH_INFO['action']
      if orders_controller.meal_match_restaurant(user, meal)
        orders_controller.add_meal(user, meal, option)
        case action
        when 'menu'
          restaurants_controller.menu(postback, user, restaurant_id: meal.restaurant.id)
        when 'next'
          next_category = meal.meal_category.lower_item
          meals_controller.index(postback, restaurant_id: meal.restaurant.id, meal_category_id: next_category.id)
        when 'cart'
          orders_controller.cart(postback, user)
        end
      else
        restaurants_controller.meal_restaurant_mismatch(postback, user, restaurant_id: meal.restaurant.id)
      end
    when 'map'
      coordinates = [user.current_order&.latitude, user.current_order&.longitude]
      messages_controller.no_restaurant(postback) unless restaurants_controller.index(postback, coordinates)
    when 'menu'
      if user.current_order&.restaurant
        restaurants_controller.menu(postback, user, restaurant_id: user.current_order.restaurant.id)
      else
        messages_controller.no_restaurant_selected(postback)
      end
    when /\Acategory_(?<meal_category_id>\w+)\z/
      meal_category_id = $LAST_MATCH_INFO['meal_category_id']
      if user.current_order&.restaurant
        meals_controller.index(postback, restaurant_id: user.current_order.restaurant.id, meal_category_id: meal_category_id)
      else
        messages_controller.no_restaurant_selected(postback)
      end
    when 'cart'
      if user.current_order&.restaurant
        orders_controller.cart(postback, user)
      else
        messages_controller.no_restaurant_selected(postback)
      end
    end
  end
end
