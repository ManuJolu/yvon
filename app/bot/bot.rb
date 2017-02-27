require 'facebook/messenger'

include Facebook::Messenger
include CloudinaryHelper

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"

  user = Bot::UsersController.new.match_user(message)

  case message.recipient['id']
  when ENV['YVON_PAGE_ID']
    BotYvon::Router.new(user).handle_message(message)
  when ENV['ALINE_PAGE_ID']
    BotAline::Router.new(user).handle_message(message)
  end
end

Bot.on :postback do |postback|
  puts "Received '#{postback.inspect}' from #{postback.sender}"

  user = Bot::UsersController.new.match_user(postback)

  case postback.recipient['id']
  when ENV['YVON_PAGE_ID']
    BotYvon::Router.new(user).handle_postback(postback)
  when ENV['ALINE_PAGE_ID']
    BotAline::Router.new(user).handle_postback(postback)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
