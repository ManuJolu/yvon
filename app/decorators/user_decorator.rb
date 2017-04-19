class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :restaurants

  delegate :url_helpers, to: 'Rails.application.routes'

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def stripe_default_source
    if stripe_default_source_brand == "American Express"
      brand = 'amex'
    else
      brand = stripe_default_source_brand.downcase
    end
    "<i class='fa fa-cc-#{brand}' aria-hidden='true'></i> •••• #{stripe_default_source_last4}".html_safe
  end

  def stripe_default_source_text
    if stripe_default_source_brand == "American Express"
      brand = 'amex'
    else
      brand = stripe_default_source_brand.downcase
    end
    "#{brand.upcase} ••••#{stripe_default_source_last4}"

  end

  def show_url(options = {})
    url_helpers.user_url(self, user_url_options(protocol: options[:protocol]))
  end

  def user_url_options(options = {})
    if options[:protocol] == 'https'
      host = 'https://yvon.herokuapp.com/'
    else
      host = 'http://www.hello-yvon.com/'
    end

    {
      host: host,
      locale: I18n.locale == I18n.default_locale ? nil : I18n.locale
    }
  end
end
