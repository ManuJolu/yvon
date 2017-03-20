class RestaurantDecorator < Draper::Decorator
  delegate_all
  decorates_association :meals

  delegate :url_helpers, to: 'Rails.application.routes'

  def address
    object.address.capitalize
  end

  def meals_url
    url_helpers.restaurant_meals_url(self, meals_url_options)
  end

  def meals_url_options
    {
      host: 'https://yvon.herokuapp.com/',
      locale: I18n.locale == I18n.default_locale ? nil : I18n.locale
    }
  end
end
