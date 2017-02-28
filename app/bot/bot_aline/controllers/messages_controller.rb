class BotAline::MessagesController
  def initialize(message, user)
    @view = BotAline::MessagesView.new(message, user)
  end

  def hello
    view.hello
  end

  def no_restaurant
    view.no_restaurant
  end

  def no_restaurant_connected
    view.no_restaurant_connected
  end

  private

  attr_reader :view
end
