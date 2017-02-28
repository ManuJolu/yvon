class BotAline::RestaurantsView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def index(coordinates, restaurants)
    colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970', '0d644e', '9c3e9a', '364c59']

    url_array = [
      "http://maps.googleapis.com/maps/api/staticmap", # base
      "?center=#{coordinates[0]},+#{coordinates[1]}", # center
      # "&zoom=15", zoom
      "&scale=2", # scale
      "&size=382x382", # size
      "&maptype=roadmap&format=png&visual_refresh=true", # format
      "&key=#{ENV['GOOGLE_API_KEY']}", # key
      "&markers=size:mid%7Ccolor:0x#{colors[0]}%7Clabel:%7C#{coordinates[0]},#{coordinates[1]}" # user_marker
    ]

    elements = restaurants.map.with_index do |restaurant, i|
      url_array << "&markers=size:mid%7Ccolor:0x#{colors[(i + 1) % 8]}%7Clabel:#{i + 1}%7C#{restaurant.latitude},#{restaurant.longitude}"
      title = "#{i + 1} - #{restaurant.name}"
      {
        title: title,
        image_url: cl_image_path(restaurant.photo.path, transformation: [
          { width: 382, height: 180, crop: :fill },
          { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
        ]),
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.restaurant.index.enter'),
            payload: "restaurant_#{restaurant.id}"
          }
        ]
      }
    end

    message.reply(
      attachment: {
        type: 'image',
        payload: {
          url: url_array.join
        }
      }
    )
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: elements
        }
      }
    )
  end

  def login(restaurant)
    message.reply(
      text: "Tu vas recevoir les commandes",
      quick_replies: [
        {
          content_type: 'text',
          title: 'Commandes en cours',
          payload: 'pending_orders'
        },
        {
          content_type: 'text',
          title: 'Service on/off',
          payload: 'duty'
        },
        {
          content_type: 'text',
          title: 'Temps de préparation',
          payload: 'preparation_time'
        }
      ]
    )
  end

  def logout(logout_user, restaurant, user)
    Facebook::Messenger::Bot.deliver({
      recipient: {
        id: user.messenger_aline_id
      },
      message: {
        text: "#{logout_user.first_name}, you have been disconnected from #{restaurant.name} by #{user.decorate.name}"
      }},
      access_token: ENV['ALINE_ACCESS_TOKEN']
    )
  end

  private

  attr_reader :message, :user
end
