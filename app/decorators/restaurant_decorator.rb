class RestaurantDecorator < Draper::Decorator
  delegate_all
  decorates_association :meals, scope: :by_category

  def address
    object.address.capitalize
  end
end
