require 'facebook/messenger'

include Facebook::Messenger
include ApplicationHelper
include CloudinaryHelper

Bot.on :message do |message|
  message.type
  puts "Received '#{message.inspect}' from #{message.sender}"
  case message.recipient['id']
  when ENV['YVON_PAGE_ID']
    BotYvon::Router.new(message)
  when ENV['ALINE_PAGE_ID']
    BotAline::Router.new(message)
  end
end

Bot.on :postback do |postback|
  puts "Received '#{postback.inspect}' from #{postback.sender}"
  case postback.recipient['id']
  when ENV['YVON_PAGE_ID']
    BotYvon::Router.new(postback)
  when ENV['ALINE_PAGE_ID']
    BotAline::Router.new(postback)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
