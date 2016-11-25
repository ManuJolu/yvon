require 'facebook/messenger'

include Facebook::Messenger

@page_controller = PageController.new
@restaurant_controller = RestaurantController.new
@meal_controller = MealController.new
@order_controller = OrderController.new

# Bot.on :optin do |optin|
#   optin.sender    # => { 'id' => '1008372609250235' }
#   optin.recipient # => { 'id' => '2015573629214912' }
#   optin.sent_at   # => 2016-04-22 21:30:36 +0200
#   optin.ref       # => 'CONTACT_SKYNET'

#   optin.reply(
#     text: "Welcome! My name is Yvon, where can I help you find your restaurant?",
#     quick_replies: [
#       {
#         content_type: 'location'
#       }
#     ]
#   )

#   user_data = RestClient.get("https://graph.facebook.com/v2.6/#{optin.sender}?access_token=#{ENV['ACCESS_TOKEN']}")
#   byebug
# end

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  # Handle user authentification
  user = User.find_by(messenger_id: message.sender['id'])
  # Could implement refresh of facebook_picture_check here, or better make a cron tab for that every day?
  unless user
    user_data_json = RestClient.get("https://graph.facebook.com/v2.6/#{message.sender['id']}?access_token=#{ENV['ACCESS_TOKEN']}")
    user_data = JSON.parse user_data_json
    facebook_picture_check = user_data['profile_pic'].match(/\/\d+_(\d+)_\d+/)[1]
    user = User.find_by(facebook_picture_check: facebook_picture_check)
    if user
      user.messenger_id = message.sender['id']
    else
      user = User.new({
        messenger_id: message.sender['id'],
        email: "#{message.sender['id']}@messenger.com",
        password: Devise.friendly_token[0,20],
        first_name: user_data['first_name'],
        last_name: user_data['last_name'],
        facebook_picture_check: facebook_picture_check
      })
    end
    user.save
  end

  if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
    user.session = {
      'hello_at' => Time.now
    }
    user.save
    @restaurant_controller.index(message)
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
  user = User.find_by(messenger_id: postback.sender['id'])
  case postback.payload
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
  when 'pay'
    @order_controller.cart(postback, user)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
