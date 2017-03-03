class BotYvon::MessagesView
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
        },
        {
          content_type: 'text',
          title: 'Bordeaux',
          payload: 'bordeaux'
        }
      ]
    )
  end

  def no_restaurant_selected
    message.reply(
      text: I18n.t('bot.no_restaurant_selected'),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def else
    message.reply(
      text: I18n.t('bot.else')
    )
  end

  private

  attr_reader :message, :user
end
