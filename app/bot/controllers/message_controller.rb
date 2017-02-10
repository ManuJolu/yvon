class MessageController
  def initialize
    @view = MessageView.new
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
