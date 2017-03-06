class RestaurantDecorator < Draper::Decorator
  delegate_all
  decorates_association :meals

  def address
    object.address.capitalize
  end
end
