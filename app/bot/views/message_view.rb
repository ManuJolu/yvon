class MessageView
  def hello(message, user)
    message.reply(
      text: I18n.t('hello', username: user.first_name.capitalize, scope: :bot),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_restaurant(message)
    message.reply(
      text: "Sorry, I found no restaurants near you... Try a new location or my hometown Bordeaux to find fine restaurants for sure!",
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
      text: "Sorry, you have no restaurant selected. Can I help you find one?",
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end
end
