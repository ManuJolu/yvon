namespace :fb_update do
  desc "Update from Yvon bot"
  task yvon: :environment do
    User.where.not(messenger_id: nil).each do |user|
      user_data_json = RestClient.get("https://graph.facebook.com/v2.8/#{user.messenger_id}?access_token=#{ENV['YVON_ACCESS_TOKEN']}")
      user_data = JSON.parse user_data_json
      facebook_picture_check = user_data['profile_pic'].match(/\/(\w+).jpg/)[1]

      user.update({
        first_name: user_data['first_name'],
        last_name: user_data['last_name'],
        messenger_locale: user_data['locale'],
        facebook_picture_check: facebook_picture_check
      })
    end
  end

  desc "Update from Aline bot"
  task aline: :environment do
    User.where.not(messenger_aline_id: nil).each do |user|
      user_data_json = RestClient.get("https://graph.facebook.com/v2.8/#{user.messenger_aline_id}?access_token=#{ENV['ALINE_ACCESS_TOKEN']}")
      user_data = JSON.parse user_data_json
      facebook_picture_check = user_data['profile_pic'].match(/\/(\w+).jpg/)[1]

      user.update({
        first_name: user_data['first_name'],
        last_name: user_data['last_name'],
        messenger_locale: user_data['locale'],
        facebook_picture_check: facebook_picture_check
      })
    end
  end

  desc "Update from Facebook uid"
  task uid: :environment do
    User.where.not(uid: nil).each do |user|
      user_data_json = RestClient.get("https://graph.facebook.com/v2.8/#{user.uid}?fields=picture&access_token=#{ENV['YVON_ACCESS_TOKEN']}")
      user_data = JSON.parse user_data_json
      facebook_picture_check = user_data['picture']['data']['url'].match(/\/(\w+).jpg/)[1]

      user.update({
        facebook_picture_check: facebook_picture_check
      })
    end
  end
end
