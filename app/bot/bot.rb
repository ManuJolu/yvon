require 'facebook/messenger'

include Facebook::Messenger
include CloudinaryHelper

@page_controller = PageController.new
@user_controller = UserController.new
@restaurant_controller = RestaurantController.new
@meal_controller = MealController.new
@order_controller = OrderController.new

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  # Handle user authentification
  user = @user_controller.match_user(message)

  if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
    coordinates = @user_controller.initialize_session(message, user)
    @restaurant_controller.index(message, coordinates)
  end

  case message.text
  when /hello/i
    @page_controller.hello(message, user)
  else
    if message.text
      message.reply(
        text: "Did you say '#{message.text}'?"
      )
    end
  end
end

Bot.on :postback do |postback|
  user = @user_controller.match_user(postback)
  case postback.payload
  when 'hello'
    @page_controller.hello(postback, user)
  when /\Arestaurant_(?<id>\d+)\z/
    unless (user.session['order'] ||= {})['restaurant_id'] == $LAST_MATCH_INFO['id'].to_i
      (user.session['order'] ||= {})['restaurant_id'] = $LAST_MATCH_INFO['id'].to_i
      user.session['order']['meals'] = {}
      user.save
    end
    @meal_controller.menu(postback, restaurant_id: $LAST_MATCH_INFO['id'].to_i)
  when /\Amore_restaurant_(?<id>\d+)\z/
    @meal_controller.menu_more(postback, restaurant_id: $LAST_MATCH_INFO['id'].to_i)
  when /\Arestaurant_(?<restaurant_id>\d+)_category_(?<category>\w+)\z/
    @meal_controller.index(postback, restaurant_id: $LAST_MATCH_INFO['restaurant_id'].to_i, category: $LAST_MATCH_INFO['category'])
  when /\Ameal_(?<id>\d+)_(?<action>\w+)\z/
    meal = Meal.find($LAST_MATCH_INFO['id'])
    action = $LAST_MATCH_INFO['action']
    @order_controller.add_meal(user, $LAST_MATCH_INFO['id'])
    case action
    when 'menu'
      @meal_controller.menu(postback, restaurant_id: meal.restaurant.id)
    when 'next'
      category = Meal.categories.key(Meal.categories[meal.category] + 1)
      @meal_controller.index(postback, restaurant_id: meal.restaurant.id, category: category)
    when 'pay'
      @order_controller.cart(postback, user)
    end
  when 'menu'
    if (user.session['order'] ||= {})['restaurant_id'].present?
      @meal_controller.menu(postback, restaurant_id: user.session['order']['restaurant_id'].to_i)
    else
      @meal_controller.no_restaurant(postback)
    end
  when /\Acategory_(?<category>\w+)\z/
    if (user.session['order'] ||= {})['restaurant_id'].present?
      @meal_controller.index(postback, restaurant_id: user.session['order']['restaurant_id'].to_i, category: $LAST_MATCH_INFO['category'])
    else
      @meal_controller.no_restaurant(postback)
    end
  when 'pay'
    @order_controller.cart(postback, user)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
