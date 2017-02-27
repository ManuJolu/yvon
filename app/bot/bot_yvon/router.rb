class BotYvon::Router
  def initialize(user)
    @user = user
    @message_controller = BotYvon::MessagesController.new
    @restaurant_controller = BotYvon::RestaurantsController.new
    @meal_controller = BotYvon::MealsController.new
    @order_controller = BotYvon::OrdersController.new
  end

  def handle_message(message)
    if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
      new_order = @order_controller.create(message, @user)
      coordinates = [new_order.latitude, new_order.longitude]
      @message_controller.no_restaurant(message) unless @restaurant_controller.index(message, coordinates)
    end

    case message.text
    when /hello/i
      @message_controller.hello(message, @user)
    when /bordeaux/i
      new_order = @order_controller.create(message, @user, lat: '44.8413522', lng: '-0.5810738')
      coordinates = [new_order.latitude, new_order.longitude]
      @message_controller.no_restaurant(message) unless @restaurant_controller.index(message, coordinates)
    when /cdsbeta/i
      if @user.current_order&.restaurant
        @order_controller.confirm(message, @user)
      else
        @message_controller.no_restaurant_selected(message)
      end
    when /talisbeta/i
      if @user.current_order&.restaurant
        @order_controller.confirm(message, @user)
      else
        @message_controller.no_restaurant_selected(message)
      end
    # else
    #   if message.text
    #     @message_controller.else(message)
    #   end
    end

    case message.quick_reply
    when /demo/i
      if @user.current_order&.restaurant
        @order_controller.demo(message, @user)
      else
        @message_controller.no_restaurant_selected(message)
      end
    end
  end

  def handle_postback(postback)
    case postback.payload
    when 'start'
      @message_controller.hello(postback, @user)
    when /\Arestaurant_(?<id>\d+)_page_(?<page>\d+)\z/
      restaurant_id = $LAST_MATCH_INFO['id'].to_i
      page = $LAST_MATCH_INFO['page'].to_i
      @order_controller.update(postback, @user, restaurant_id: restaurant_id)
      @restaurant_controller.menu(postback, @user, restaurant_id: restaurant_id, page: page)
    when /\Arestaurant_(?<restaurant_id>\d+)_category_(?<meal_category_id>\w+)\z/
      restaurant_id = $LAST_MATCH_INFO['restaurant_id'].to_i
      meal_category_id = $LAST_MATCH_INFO['meal_category_id']
      if @restaurant_controller.check(@user, restaurant_id: restaurant_id)
        @meal_controller.index(postback, restaurant_id: restaurant_id, meal_category_id: meal_category_id)
      else
        @restaurant_controller.restaurant_mismatch(postback, @user, restaurant_id: restaurant_id)
      end
    when /\Ameal_(?<id>\d+)_(?<action>\D+)\z/
      meal = Meal.find($LAST_MATCH_INFO['id'])
      action = $LAST_MATCH_INFO['action']
      if @order_controller.meal_match_restaurant(@user, meal)
        if meal.options.any?
          @meal_controller.get_option(postback, meal, action: action)
        else
          @order_controller.add_meal(@user, meal)
          case action
          when 'menu'
            @restaurant_controller.menu(postback, @user, restaurant_id: meal.restaurant.id)
          when 'next'
            next_category = meal.meal_category.lower_item
            @meal_controller.index(postback, restaurant_id: meal.restaurant.id, meal_category_id: next_category.id)
          when 'cart'
            @order_controller.cart(postback, @user)
          end
        end
      else
        @restaurant_controller.meal_restaurant_mismatch(postback, @user, restaurant_id: meal.restaurant.id)
      end
    when /\Ameal_(?<meal_id>\d+)_option_(?<option_id>\d+)_(?<action>\D+)\z/
      meal = Meal.find($LAST_MATCH_INFO['meal_id'])
      option = Option.find($LAST_MATCH_INFO['option_id'])
      action = $LAST_MATCH_INFO['action']
      if @order_controller.meal_match_restaurant(@user, meal)
        @order_controller.add_meal(@user, meal, option)
        case action
        when 'menu'
          @restaurant_controller.menu(postback, @user, restaurant_id: meal.restaurant.id)
        when 'next'
          next_category = meal.meal_category.lower_item
          @meal_controller.index(postback, restaurant_id: meal.restaurant.id, meal_category_id: next_category.id)
        when 'cart'
          @order_controller.cart(postback, @user)
        end
      else
        @restaurant_controller.meal_restaurant_mismatch(postback, @user, restaurant_id: meal.restaurant.id)
      end
    when 'map'
      coordinates = [@user.current_order&.latitude, @user.current_order&.longitude]
      @message_controller.no_restaurant(postback) unless @restaurant_controller.index(postback, coordinates)
    when 'menu'
      if @user.current_order&.restaurant
        @restaurant_controller.menu(postback, @user, restaurant_id: @user.current_order.restaurant.id)
      else
        @message_controller.no_restaurant_selected(postback)
      end
    when /\Acategory_(?<meal_category_id>\w+)\z/
      meal_category_id = $LAST_MATCH_INFO['meal_category_id']
      if @user.current_order&.restaurant
        @meal_controller.index(postback, restaurant_id: @user.current_order.restaurant.id, meal_category_id: meal_category_id)
      else
        @message_controller.no_restaurant_selected(postback)
      end
    when 'cart'
      if @user.current_order&.restaurant
        @order_controller.cart(postback, @user)
      else
        @message_controller.no_restaurant_selected(postback)
      end
    end
  end
end
