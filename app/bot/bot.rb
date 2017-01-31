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
    @message_controller.no_restaurant unless @restaurant_controller.index(message, coordinates)
  else
    if message.text
      message.reply(
        text: "Say 'Hello' to start a new order"
      )
    end
  end
end

Bot.on :postback do |postback|
  user = @user_controller.match_user(postback)
  case postback.payload
  when 'start'
    @message_controller.hello(postback, user)
  when /\Arestaurant_(?<id>\d+)\z/
    restaurant_id = $LAST_MATCH_INFO['id'].to_i
    @order_controller.update(postback, user, restaurant_id: restaurant_id)
    @restaurant_controller.menu(postback, restaurant_id: restaurant_id)
  when /\Amore_restaurant_(?<id>\d+)\z/
    restaurant_id = $LAST_MATCH_INFO['id'].to_i
    @restaurant_controller.menu_more(postback, restaurant_id: restaurant_id)
  when /\Arestaurant_(?<restaurant_id>\d+)_category_(?<category>\w+)\z/
    restaurant_id = $LAST_MATCH_INFO['restaurant_id'].to_i
    category = $LAST_MATCH_INFO['category']
    if @restaurant_controller.check(user, restaurant_id: restaurant_id)
      @meal_controller.index(postback, restaurant_id: restaurant_id, category: category)
    else
      @restaurant_controller.restaurant_mismatch(postback, user, restaurant_id: restaurant_id)
    end
  when /\Ameal_(?<id>\d+)_(?<action>\w+)\z/
    meal = Meal.find($LAST_MATCH_INFO['id'])
    action = $LAST_MATCH_INFO['action']
    if @order_controller.meal_match_restaurant(user, meal)
      @order_controller.add_meal(user, meal)
      case action
      when 'menu'
        @restaurant_controller.menu(postback, restaurant_id: meal.restaurant.id)
      when 'next'
        category = Meal.categories.key(Meal.categories[meal.category] + 1)
        @meal_controller.index(postback, restaurant_id: meal.restaurant.id, category: category)
      when 'pay'
        @order_controller.cart(postback, user)
      end
    else
      @restaurant_controller.meal_restaurant_mismatch(postback, user, restaurant_id: meal.restaurant.id)
    end
  when 'menu'
    if user.current_order&.restaurant
      @restaurant_controller.menu(postback, restaurant_id: user.current_order.restaurant.id)
    else
      @restaurant_controller.no_restaurant_selected(postback)
    end
  when /\Acategory_(?<category>\w+)\z/
    category = $LAST_MATCH_INFO['category']
    if user.current_order&.restaurant
      @meal_controller.index(postback, restaurant_id: user.current_order.restaurant.id, category: category)
    else
      @restaurant_controller.no_restaurant_selected(postback)
    end
  when 'pay'
    @order_controller.cart(postback, user)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
