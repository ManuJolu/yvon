class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :restaurants

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  def stripe_default_source
    "<i class='fa fa-cc-#{stripe_default_source_brand.downcase}' aria-hidden='true'></i> •••• #{stripe_default_source_last4}".html_safe
  end
end
