class RestaurantView
  def index(message, coordinates, restaurants)
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
    if restaurants.present?
      elements = restaurants.map.with_index do |restaurant, i|
        url_array << "&markers=size:mid%7Ccolor:0x#{colors[(i + 1) % 8]}%7Clabel:#{i + 1}%7C#{restaurant.latitude},#{restaurant.longitude}"
        {
          title: "#{i + 1} - ready in #{restaurant.preparation_time}min - #{restaurant.name}",
          item_url: restaurant.facebook_url,
          image_url: cl_image_path(restaurant.photo.path, transformation: [
            { width: 382, height: 180, crop: :fill },
            { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
          ]),
          subtitle: "#{(restaurant.distance_from(coordinates)*1000).round}m heading #{Geocoder::Calculations.compass_point(restaurant.bearing_from(coordinates))} - #{restaurant.category.capitalize} food\n#{restaurant.description}",
          buttons: [
            {
              type: 'postback',
              title: 'Enter',
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
    else
      message.reply(
        text: "Sorry, I found no restaurants near you... Can I help you again?",
        quick_replies: [
          {
            content_type: 'location'
          }
        ]
      )
    end
  end
end
