require 'facebook/messenger'

include Facebook::Messenger
include CloudinaryHelper

Bot.on :message do |message|
  puts "Received '#{message.inspect}' from #{message.sender}"
  case message.recipient['id']
  when ENV['YVON_PAGE_ID']
    YvonRouter.new.handle_message(message)
  when ENV['ALINE_PAGE_ID']
    AlineRouter.new.handle_message(message)
  end
end

Bot.on :postback do |postback|
  puts "Received '#{postback.inspect}' from #{postback.sender}"
  case postback.recipient['id']
  when ENV['YVON_PAGE_ID']
    YvonRouter.new.handle_postback(postback)
  when ENV['ALINE_PAGE_ID']
    AlineRouter.new.handle_postback(postback)
  end
end

Bot.on :delivery do |delivery|
  puts "Delivered message(s) #{delivery.ids}"
end
