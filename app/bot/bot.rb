require 'facebook/messenger'

include Facebook::Messenger

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  case message.text
  when /hello/i
    message.reply(
      text: 'Hello, human!',
      quick_replies: [
        {
          content_type: 'text',
          title: 'Hello, bot!',
          payload: 'HELLO_BOT'
        }
      ]
    )
  when /something humans like/i
    message.reply(
      text: 'I found something humans seem to like:'
    )

    message.reply(
      attachment: {
        type: 'image',
        payload: {
          url: 'https://i.imgur.com/iMKrDQc.gif'
        }
      }
    )

    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: 'Did human like it?',
          buttons: [
            { type: 'postback', title: 'Yes', payload: 'HUMAN_LIKED' },
            { type: 'postback', title: 'No', payload: 'HUMAN_DISLIKED' }
          ]
        }
      }
    )
  else
    message.reply(
      text: 'You are now marked for extermination.'
    )

    message.reply(
      text: 'Have a nice day.'
    )
  end
end

Bot.on :postback do |postback|
  case postback.payload
  when 'HUMAN_LIKED'
    text = 'That makes bot happy!'
  when 'HUMAN_DISLIKED'
    text = 'Oh.'
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
