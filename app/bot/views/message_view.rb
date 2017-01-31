class MessageView
  def hello(message, user)
    message.reply(
      text: "Hello #{user.first_name.capitalize}! Where can I help you find your restaurant?",
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_restaurant(message)
    message.reply(
      text: "Sorry, I found no restaurants near you... Try a new location or
        my hometown Bordeaux to find fine restaurants for sure!",
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
