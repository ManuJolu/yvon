class BotAlineUserFinder < BotUserFinder
  private

  def messenger_field
    :messenger_aline_id
  end

  def access_token
    ENV['ALINE_ACCESS_TOKEN']
  end
end
