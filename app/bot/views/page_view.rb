class PageView
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
end
