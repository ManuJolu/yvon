Bot.on :postback do |postback|
  postback.sender    # => { 'id' => '1008372609250235' }
  postback.recipient # => { 'id' => '2015573629214912' }
  postback.sent_at   # => 2016-04-22 21:30:36 +0200
  postback.payload   # => 'EXTERMINATE'
  ActivityController.new(postback.sender, postback.recipient)
  case postback.payload
  when 'EXTERMINATE'
    @activity_controller.exterminate()
  end
end
# activity_controller.rb
class ActivityController
  def initialize(sender_id, recipient, sent_at, payload)
    @view = ActivityView
    @sender = sender
    # etc.
  end
  def exterminate
    @user = User.find_by(sender_id: sender_id)
    @user.events.destroy_all
    @view.confirm_exterminate
  end
end
class ActivityView
  def confirm_exterminate
    Bot.deliver(
      recipient: {
        id: '45123'
      },
      message: {
        text: 'All your events have been exterminated'
      },
      access_token: ENV['ACCESS_TOKEN']
    )
  end
end
