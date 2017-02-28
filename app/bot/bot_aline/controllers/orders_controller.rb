class BotAline::OrdersController
  def initialize(message, user)
    @view = BotAline::OrdersView.new(message, user)
  end

  private

  attr_reader :view
end
