class BotUserFinder
  def initialize(message)
    user = User.find_by(messenger_field => message.sender['id'])
    # Could implement refresh of facebook_picture_check here, or better make a cron tab for that every day?
    unless user
      user_data_json = RestClient.get("https://graph.facebook.com/v2.6/#{message.sender['id']}?access_token=#{access_token}")
      user_data = JSON.parse user_data_json
      facebook_picture_check = user_data['profile_pic'].match(/\/\d+_(\d+)_\d+/)[1]
      user = User.find_by(facebook_picture_check: facebook_picture_check)
      if user
        user.send("#{messenger_field}=", message.sender['id'])
      else
        user = User.new({
          messenger_field => message.sender['id'],
          email: "#{message.sender['id']}@messenger.com",
          password: Devise.friendly_token[0,20],
          first_name: user_data['first_name'],
          last_name: user_data['last_name'],
          facebook_picture_check: facebook_picture_check
        })
      end
      user.save
    end
    @user = user
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
