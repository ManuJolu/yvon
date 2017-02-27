class BotProvider < Facebook::Messenger::Configuration::Providers::Base
  def valid_verify_token?(verify_token)
    (verify_token == ENV['BOT_VERIFY_TOKEN'])
  end

  def app_secret_for(page_id)
    case page_id['id']
    when ENV['YVON_PAGE_ID']
      ENV['YVON_APP_SECRET']
    when ENV['ALINE_PAGE_ID']
      ENV['ALINE_APP_SECRET']
    end
  end

  def access_token_for(page_id)
    case page_id['id']
    when ENV['YVON_PAGE_ID']
      ENV['YVON_ACCESS_TOKEN']
    when ENV['ALINE_PAGE_ID']
      ENV['ALINE_ACCESS_TOKEN']
    end
  end
end
