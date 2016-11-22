require 'facebook/messenger'

include Facebook::Messenger

@restaurant_controller = RestaurantController.new

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

# Bot.on :postback do |postback|
#   postback.sender    # => { 'id' => '1008372609250235' }
#   postback.recipient # => { 'id' => '2015573629214912' }
#   postback.sent_at   # => 2016-04-22 21:30:36 +0200
#   postback.payload   # => 'EXTERMINATE'
#   ActivityController.new(postback.sender, postback.recipient)
#   case postback.payload
#   when 'EXTERMINATE'
#     @activity_controller.exterminate()
#   end
# end

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
    @restaurant_controller.index(message)
  end

  case message.text
  when /hello/i
    @restaurant_controller.hello(message)
  when /meal/i
    elements = []
    4.times do |i|
      elements << {
        title: "Plat #{i}",
        image_url: 'http://www.formation-pizza-marketing.com/wp-content/uploads/2014/01/pizza-malbouffe-plat-equilibre2.jpg',
        subtitle: "Description plat #{i}\nOrder and:",
        buttons: [
          {
            type: 'postback',
            title: 'Pay',
            payload: "MEAL_#{i}"
          },
          {
            type: 'postback',
            title: 'Menu',
            payload: "MEAL_#{i}"
          },
          {
            type: 'postback',
            title: 'Desserts',
            payload: "MEAL_#{i}"
          }
        ]
      }
    end
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: elements
        }
      }
    )
  when /menu/i
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'list',
          elements: [
            {
              title: "L'évidence café",
              image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
              subtitle: "Carte du jour",
              default_action: {
                type: "web_url",
                url: "https://yvon.herokuapp.com/",
                messenger_extensions: true,
                webview_height_ratio: "tall",
                fallback_url: "https://yvon.herokuapp.com/"
              }
              # buttons: [
              #   {
              #       title: "View",
              #       type: "web_url",
              #       url: "https://fcatuhe.github.io/lewagon/",
              #       messenger_extensions: true,
              #       webview_height_ratio: "tall",
              #       fallback_url: "https://fcatuhe.github.io/lewagon/"
              #   }
              # ]
            },
            {
              title: "Entrées",
              image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
              subtitle: "100% mise en appétit",
              default_action: {
                type: "web_url",
                url: "https://yvon.herokuapp.com/",
                messenger_extensions: true,
                webview_height_ratio: "tall",
                fallback_url: "https://yvon.herokuapp.com/"
              },
              buttons: [
                {
                    title: "Commander",
                    type: "web_url",
                    url: "https://yvon.herokuapp.com/",
                    messenger_extensions: true,
                    webview_height_ratio: "tall",
                    fallback_url: "https://yvon.herokuapp.com/"
                }
              ]
            },
            {
              title: "Plats",
              image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
              subtitle: "100% local",
              default_action: {
                type: "web_url",
                url: "https://yvon.herokuapp.com/",
                messenger_extensions: true,
                webview_height_ratio: "tall",
                fallback_url: "https://yvon.herokuapp.com/"
              },
              buttons: [
                {
                    title: "Commander",
                    type: "web_url",
                    url: "https://yvon.herokuapp.com/",
                    messenger_extensions: true,
                    webview_height_ratio: "tall",
                    fallback_url: "https://yvon.herokuapp.com/"
                }
              ]
            },
            {
              title: "Desserts",
              image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
              subtitle: "100% gourmandise",
              default_action: {
                type: "web_url",
                url: "https://yvon.herokuapp.com/",
                messenger_extensions: true,
                webview_height_ratio: "tall",
                fallback_url: "https://yvon.herokuapp.com/"
              },
              buttons: [
                {
                    title: "Commander",
                    type: "web_url",
                    url: "https://yvon.herokuapp.com/",
                    messenger_extensions: true,
                    webview_height_ratio: "tall",
                    fallback_url: "https://yvon.herokuapp.com/"
                }
              ]
            }
          ]
        }
      }
    )
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
  when /MEAL_(?<id>\d+)/
    text = "Meal #{$LAST_MATCH_INFO['id']} added to order"
  end

  postback.reply(
    text: text
  )
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
