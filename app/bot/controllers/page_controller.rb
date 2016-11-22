class PageController
  def initialize
    @view = PageView.new
  end

  def hello(message)
    @view.hello(message)
  end
end
