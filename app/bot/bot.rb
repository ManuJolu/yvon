require 'facebook/messenger'

include Facebook::Messenger
include CloudinaryHelper

@message_controller = MessageController.new
@user_controller = UserController.new
@restaurant_controller = RestaurantController.new
@meal_controller = MealController.new
@order_controller = OrderController.new

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  # Handle user authentification
  user = @user_controller.match_user(message)

  if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
    new_order = @order_controller.create(message, user)
    coordinates = [new_order.latitude, new_order.longitude]
    @message_controller.no_restaurant(message) unless @restaurant_controller.index(message, coordinates)
  end

  case message.text
  when /hello/i
    @message_controller.hello(message, user)
  when /bordeaux/i
    new_order = @order_controller.create(message, user, lat: '44.840715', lng: '-0.5721098')
    coordinates = [new_order.latitude, new_order.longitude]
    @message_controller.no_restaurant(message) unless @restaurant_controller.index(message, coordinates)
  when /cdiscount-beta/i
    if user.current_order&.restaurant
      @order_controller.confirm(message, user)
    else
      @message_controller.no_restaurant_selected(message)
    end
  when /demo/i
    if user.current_order&.restaurant
      @order_controller.demo(message, user)
    else
      @message_controller.no_restaurant_selected(message)
    end
  # else
  #   if message.text
  #     @message_controller.else(message)
  #   end
  end
end

Bot.on :postback do |postback|
  user = @user_controller.match_user(postback)
  case postback.payload
  when 'start'
    @message_controller.hello(postback, user)
  when /\Arestaurant_(?<id>\d+)_page_(?<page>\d+)\z/
    restaurant_id = $LAST_MATCH_INFO['id'].to_i
    page = $LAST_MATCH_INFO['page'].to_i
    @order_controller.update(postback, user, restaurant_id: restaurant_id)
    @restaurant_controller.menu(postback, restaurant_id: restaurant_id, page: page)
  when /\Arestaurant_(?<restaurant_id>\d+)_category_(?<meal_category_id>\w+)\z/
    restaurant_id = $LAST_MATCH_INFO['restaurant_id'].to_i
    meal_category_id = $LAST_MATCH_INFO['meal_category_id']
    if @restaurant_controller.check(user, restaurant_id: restaurant_id)
      @meal_controller.index(postback, restaurant_id: restaurant_id, meal_category_id: meal_category_id)
    else
      @restaurant_controller.restaurant_mismatch(postback, user, restaurant_id: restaurant_id)
    end
  when /\Ameal_(?<id>\d+)_(?<action>\D+)\z/
    meal = Meal.find($LAST_MATCH_INFO['id'])
    action = $LAST_MATCH_INFO['action']
    if @order_controller.meal_match_restaurant(user, meal)
      if meal.options.any?
        @meal_controller.get_option(postback, meal, action: action)
      else
        @order_controller.add_meal(user, meal)
        case action
        when 'menu'
          @restaurant_controller.menu(postback, restaurant_id: meal.restaurant.id)
        when 'next'
          next_category = meal.meal_category.lower_item
          @meal_controller.index(postback, restaurant_id: meal.restaurant.id, meal_category_id: next_category.id)
        when 'cart'
          @order_controller.cart(postback, user)
        end
      end
    else
      @restaurant_controller.meal_restaurant_mismatch(postback, user, restaurant_id: meal.restaurant.id)
    end
  when /\Ameal_(?<meal_id>\d+)_option_(?<option_id>\d+)_(?<action>\D+)\z/
    meal = Meal.find($LAST_MATCH_INFO['meal_id'])
    option = Option.find($LAST_MATCH_INFO['option_id'])
    action = $LAST_MATCH_INFO['action']
    if @order_controller.meal_match_restaurant(user, meal)
      @order_controller.add_meal(user, meal, option)
      case action
      when 'menu'
        @restaurant_controller.menu(postback, restaurant_id: meal.restaurant.id)
      when 'next'
        next_category = meal.meal_category.lower_item
        @meal_controller.index(postback, restaurant_id: meal.restaurant.id, meal_category_id: next_category.id)
      when 'cart'
        @order_controller.cart(postback, user)
      end
    else
      @restaurant_controller.meal_restaurant_mismatch(postback, user, restaurant_id: meal.restaurant.id)
    end

  when 'menu'
    if user.current_order&.restaurant
      @restaurant_controller.menu(postback, restaurant_id: user.current_order.restaurant.id)
    else
      @message_controller.no_restaurant_selected(postback)
    end
  when /\Acategory_(?<meal_category_id>\w+)\z/
    meal_category_id = $LAST_MATCH_INFO['meal_category_id']
    if user.current_order&.restaurant
      @meal_controller.index(postback, restaurant_id: user.current_order.restaurant.id, meal_category_id: meal_category_id)
    else
      @message_controller.no_restaurant_selected(postback)
    end
  when 'cart'
    if user.current_order&.restaurant
      @order_controller.cart(postback, user)
    else
      @message_controller.no_restaurant_selected(postback)
    end
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
