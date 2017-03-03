class BotYvon::MessagesController
  def initialize(message, user)
    @view = BotYvon::MessagesView.new(message, user)
  end

  def hello
    view.hello
  end

  def no_restaurant
    view.no_restaurant
  end

  def no_restaurant_selected
    view.no_restaurant_selected
  end

  def else
    view.else
  end

  private

  attr_reader :view
end
