class BotAline::MessagesView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def hello
    message.reply(
      text: I18n.t('bot.hello', username: user.first_name.capitalize),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_restaurant
    message.reply(
      text: I18n.t('bot.no_restaurant'),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end


  private

  attr_reader :message, :user
end
