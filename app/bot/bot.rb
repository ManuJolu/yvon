require 'facebook/messenger'

include Facebook::Messenger

@page_controller = PageController.new
@restaurant_controller = RestaurantController.new
@meal_controller = MealController.new

Bot.on :optin do |optin|
  optin.sender    # => { 'id' => '1008372609250235' }
  optin.recipient # => { 'id' => '2015573629214912' }
  optin.sent_at   # => 2016-04-22 21:30:36 +0200
  optin.ref       # => 'CONTACT_SKYNET'

  optin.reply(
    text: "Welcome! My name is Yvon, where can I help you find your restaurant?",
    quick_replies: [
      {
        content_type: 'location'
      }
    ]
  )

  user_data = RestClient.get("https://graph.facebook.com/v2.6/#{optin.sender}?access_token=#{ENV['ACCESS_TOKEN']}")
  byebug
end

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
    @restaurant_controller.index(message)
  end

  case message.text
  when /hello/i
    @page_controller.hello(message)
  when /menu/i
    @meal_controller.menu(message)
  when /meal/i
    @meal_controller.index(message)
  else
    if message.text
      message.reply(
        text: "Did you say '#{message.text}'?"
      )
    end
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when /restaurant_(?<id>\d+)/
    @meal_controller.menu(postback, restaurant_id: $LAST_MATCH_INFO['id'].to_i)
  when /more_restaurant_(?<id>\d+)/
    @meal_controller.menu_more(postback, restaurant_id: $LAST_MATCH_INFO['id'].to_i)
  when /category_(?<id>\d+)/
    @meal_controller.index(postback, category_id: $LAST_MATCH_INFO['id'].to_i)
  when /meal_(?<id>\d+)/
    text = "Meal #{$LAST_MATCH_INFO['id']} added to order"
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
