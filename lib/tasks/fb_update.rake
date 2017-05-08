namespace :fb_update do
  desc "Update from Yvon bot"
  task yvon: :environment do
    User.where.not(messenger_id: nil).each do |user|
      user_data_json = RestClient.get("https://graph.facebook.com/v2.9/#{user.messenger_id}?access_token=#{ENV['YVON_ACCESS_TOKEN']}")
      user_data = JSON.parse user_data_json
      if user_data.present?
        user.update({
          first_name: user_data['first_name'],
          last_name: user_data['last_name'],
          messenger_locale: user_data['locale'],
        })
      end
    end
  end

  desc "Update from Aline bot"
  task aline: :environment do
    User.where.not(messenger_aline_id: nil).each do |user|
      user_data_json = RestClient.get("https://graph.facebook.com/v2.9/#{user.messenger_aline_id}?access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
      user_data = JSON.parse user_data_json
      if user_data.present?
        user.update({
          first_name: user_data['first_name'],
          last_name: user_data['last_name'],
          messenger_locale: user_data['locale'],
        })
      end
    end
  end
end
