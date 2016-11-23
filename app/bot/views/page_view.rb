class PageView
  def hello(message)
    message.reply(
      text: 'Hello! Where can I help you find your restaurant?',
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end
end
