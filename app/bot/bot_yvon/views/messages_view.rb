class BotYvon::MessagesView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def hello(options = {})
  keyword = (options[:keyword]&.capitalize || I18n.t('bot.hello_default_keyword'))
  message.reply(
    text: I18n.t('bot.hello', keyword: keyword, username: user.first_name.capitalize),
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

  def share
  message.reply(
    attachment: {
      type: 'template',
      payload: {
        template_type: 'generic',
        image_aspect_ratio: 'square',
        elements: [
          {
            title: I18n.t('bot.share'),
            image_url: cl_image_path("yvon_messenger_code.png", width: 400, height: 400, crop: :fill),
            buttons: [
              {
                type: 'element_share',
                share_contents: {
                  attachment: {
                    type: 'template',
                    payload: {
                      template_type: 'generic',
                      image_aspect_ratio: 'square',
                      elements: [
                        {
                          title: I18n.t('bot.share'),
                          image_url: cl_image_path("yvon_messenger_code.png", width: 400, height: 400, crop: :fill),
                          buttons: [
                            {
                              type: 'web_url',
                              title: I18n.t('bot.shared_m_me'),
                              url: "http://m.me/HelloYvon?ref=shared"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              }
            ]
          }
        ]
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

  def no_current_order
    message.reply(
      text: I18n.t('bot.no_current_order'),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_comprendo
    message.reply(
      text: I18n.t('bot.no_comprendo')
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
