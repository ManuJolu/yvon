class YvonBot::MessagesController
  def initialize
    @view = YvonBot::MessagesView.new
  end

  def hello(message, user)
    @view.hello(message, user)
  end

  def no_restaurant(message)
    @view.no_restaurant(message)
  end

  def no_restaurant_selected(postback)
    @view.no_restaurant_selected(postback)
  end

  def else(message)
    @view.else(message)
  end
end
