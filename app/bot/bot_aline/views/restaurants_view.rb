class BotAline::RestaurantsView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def pass(restaurant_id, params)
    if params[:step] == 0
      text = "Mot de passe :"
      quick_replies = (0..9).map do |i|
        {
          content_type: 'text',
          title: "#{i}",
          payload: "restaurant_#{restaurant_id}_pass_#{i}"
        }
      end
    else
      text = "..."
      quick_replies = (0..9).map do |i|
        {
          content_type: 'text',
          title: "#{i}",
          payload: "restaurant_#{restaurant_id}_pass_#{params[:attempt]}#{i}"
        }
      end
    end

    message.reply(
      text: text,
      quick_replies: quick_replies
    )
  end

  def wrong_pass
    message.reply(
      text: "Identification échouée."
    )
  end

  def logged_in(restaurant)
    message.reply(
      text: "Tu es connecté au #{restaurant.name}, tu vas recevoir les commandes."
    )
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
        image_url: cl_image_path_with_default(restaurant.photo&.path, transformation: [
          { width: 382, height: 180, crop: :fill },
          { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
        ]),
        buttons: [
          {
            type: 'postback',
            title: "Connexion",
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

  def duty(restaurant)
    if restaurant.on_duty?
      text = "Service OUVERT"
      buttons = [{ type: 'postback', title: 'Fermer', payload: "restaurant_#{restaurant.id}_duty_off" }]
    else
      text = "Service FERMÉ"
      buttons = [{ type: 'postback', title: 'Ouvrir', payload: "restaurant_#{restaurant.id}_duty_on" }]
    end

    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: text,
          buttons: buttons
        }
      }
    )
  end

  def preparation_time(restaurant)
    text = "#{restaurant.preparation_time} min\nSélectionne pour modifier :"
    preparation_times = ((restaurant.preparation_time - 5...restaurant.preparation_time + 6).to_a - [restaurant.preparation_time])
    quick_replies = preparation_times.map do |preparation_time|
      {
        content_type: 'text',
        title: "#{preparation_time} min",
        payload: "restaurant_#{restaurant.id}_preparation_time_#{preparation_time}"
      }
    end

    message.reply(
      text: text,
      quick_replies: quick_replies
    )
  end

  private

  attr_reader :message, :user
end
