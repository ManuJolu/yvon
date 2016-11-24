class PageController
  def initialize
    @view = PageView.new
  end

  def hello(message, user)
    @view.hello(message, user)
  end
end
