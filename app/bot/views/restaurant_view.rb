require 'cloudinary'

include CloudinaryHelper

class RestaurantView
  def index(message, coordinates, restaurants)
    colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970']
    url_array = [
      base = "http://maps.googleapis.com/maps/api/staticmap",
      center = "?center=#{coordinates[0]},+#{coordinates[1]}",
      # zoom = "&zoom=15",
      scale = "&scale=2",
      size = "&size=382x382",
      format = "&maptype=roadmap&format=png&visual_refresh=true",
      key = "&key=#{ENV['GOOGLE_API_KEY']}",
      user_marker = "&markers=size:mid%7Ccolor:0x#{colors[0]}%7Clabel:%7C#{coordinates[0]},+#{coordinates[1]}"
    ]
    if restaurants.present?
      elements = restaurants.map.with_index do |restaurant, i|
        url_array << "&markers=size:mid%7Ccolor:0x#{colors[(i + 1) % 5]}%7Clabel:#{i + 1}%7C#{restaurant.address.tr(' ', '+')}"
        {
          title: "#{i + 1} - ready in #{rand(5..25)}min - #{restaurant.name}",
          item_url: "#{restaurant.facebook_url}",
          image_url: "#{cl_image_path restaurant.photo.path, width: 382, height: 200, crop: :fill, border: "5px_solid_rgb:#{colors[(i + 1) % 5]}"}",
          subtitle: "#{(restaurant.distance_from(coordinates)*1000).round}m heading #{Geocoder::Calculations.compass_point(restaurant.bearing_from(coordinates))}\n#{restaurant.description}",
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
        text: "Sorry, I found no restaurants near you...",
        quick_replies: [
          {
            content_type: 'location'
          }
        ]
      )
    end
  end
end
