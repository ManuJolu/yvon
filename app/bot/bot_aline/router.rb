class BotAline::Router
  def initialize(user)
    @user = user
  end

  def handle_message(message)
    # Handle user authentification
    # user = @user_controller.match_user(message)

    case message.text
    when /hello/i
      message.reply(
        text: "Hello, I'm Aline!"
      )
    else
      message.reply(
        text: "Aline asking: Did you say '#{message.text}'?"
      )
    end
  end
end
