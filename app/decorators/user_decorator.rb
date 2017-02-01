class UserDecorator < Draper::Decorator
  delegate_all
  decorates_association :restaurants

  def name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end
end
