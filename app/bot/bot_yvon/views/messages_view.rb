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

  def share
  message.reply(
    attachment: {
      type: 'template',
      payload: {
        template_type: 'generic',
        elements: {
          title: "Salut, essaye Yvon pour commander tes plats le midi !",
          image_url: cl_image_path(Restaurant.last.photo.path),
          subtitle: "sous-titre",
          # buttons: [
          #   {
          #     type: 'element_share',
          #   }
          # ]
        }
      }
    }
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
