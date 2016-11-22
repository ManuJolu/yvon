require 'facebook/messenger'

include Facebook::Messenger

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  case message.text
  when /hello/i
    message.reply(
      text: 'Where are you?',
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
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
    if message.attachments.try(:[], 0).try(:[], 'payload').try(:[], 'coordinates')
      lat = message.attachments[0]['payload']['coordinates']['lat']
      lng = message.attachments[0]['payload']['coordinates']['long']
      message.reply(
        text: "Your coordinates: #{lat}, #{lng}"
      )
    elsif message.text
      message.reply(
        text: "Did you say '#{message.text}'?"
      )
    else
      message.reply(
        text: "Did not understand"
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
# # activity_controller.rb
# class ActivityController
#   def initialize(sender_id, recipient, sent_at, payload)
#     @view = ActivityView
#     @sender = sender
#     # etc.
#   end
#   def exterminate
#     @user = User.find_by(sender_id: sender_id)
#     @user.events.destroy_all
#     @view.confirm_exterminate
#   end
# end
# class ActivityView
#   def confirm_exterminate
#     Bot.deliver(
#       recipient: {
#         id: '45123'
#       },
#       message: {
#         text: 'All your events have been exterminated'
#       },
#       access_token: ENV['ACCESS_TOKEN']
#     )
#   end
# end
