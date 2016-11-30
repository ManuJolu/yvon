class RestaurantDecorator < Draper::Decorator
  delegate_all
  decorates_association :meals, scope: :by_category
  # decorates_association :orders, scope: :persisted

  def address
    address.capitalize
  end

end
