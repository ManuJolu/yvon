class BotAline::MessagesView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def hello
    message.reply(
      text: "Salut #{user.first_name.capitalize}, où se situe ton restaurant ?",
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_restaurant
    message.reply(
      text: "Je ne le trouve pas, es-tu sûr de m'avoir indiqué le bon endroit ?",
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def no_restaurant_connected
    message.reply(
      text: "Tu n'es pas encore connecté, où se situe ton restaurant ?",
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
