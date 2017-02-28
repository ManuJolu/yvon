class BotAline::OrdersView
  def initialize(message, user)
    @message = message
    @user = user
  end

  private

  attr_reader :message, :user
end
