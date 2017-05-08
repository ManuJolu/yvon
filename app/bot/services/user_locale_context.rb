class UserLocaleContext
  def initialize(user)
    if I18n.available_locales.include?(user.messenger_locale&.first(2)&.to_sym)
      @locale = user.messenger_locale.first(2).to_sym
     else
      @locale = :en
    end
  end

  def call
    previous_locale = I18n.locale
    I18n.locale = @locale
    yield
    I18n.locale = previous_locale
  end
end
