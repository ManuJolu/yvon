class BotYvon::MessagesView
  def hello(message, user)
    message.reply(
      text: I18n.t('bot.hello', username: user.first_name.capitalize),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_restaurant(message)
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

  def no_restaurant_selected(postback)
    postback.reply(
      text: I18n.t('bot.no_restaurant_selected'),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def else(message)
    message.reply(
      text: I18n.t('bot.else')
    )
  end
end
