class FindBotYvonUser
  def initialize(message)
    @user = User.find_by(messenger_field => message.sender['id'])
    unless @user
      id_matching = JSON.parse(RestClient.get("https://graph.facebook.com/v2.9"\
        "/#{message.sender['id']}/ids_for_apps"\
        "?app=#{ENV['YVON_APP_ID']}"\
        "&access_token=#{access_token}"))
      user_data = JSON.parse RestClient.get("https://graph.facebook.com/v2.9"\
        "/#{message.sender['id']}?access_token=#{access_token}")
      @user = User.find_by(uid: id_matching['data'].first.try(:[], 'id'))
      if @user
        @user.send("#{messenger_field}=", message.sender['id'])
      else
        @user = User.new({
          messenger_field => message.sender['id'],
          email: "#{message.sender['id']}@messenger.com",
          password: Devise.friendly_token[0,20],
          first_name: user_data['first_name'],
          last_name: user_data['last_name'],
        })
      end
      @user.messenger_locale = user_data['locale']
      @user.save
    end
    I18n.locale = I18n.available_locales.include?(@user.messenger_locale&.first(2)&.to_sym) ? @user.messenger_locale.first(2).to_sym : :en
  end

  def call
    @user
  end

  private

  def messenger_field
    :messenger_id
  end

  def access_token
    ENV['YVON_ACCESS_TOKEN']
  end
end
