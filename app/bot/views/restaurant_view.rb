require 'cloudinary'

include CloudinaryHelper

class RestaurantView
  def index(message, coordinates, restaurants)
    if restaurants.present?
      elements = restaurants.map do |restaurant|
        {
          title: "#{restaurant.name}",
          item_url: "https://www.facebook.com/levidencecafe33/",
          image_url: "#{cl_image_path restaurant.photo.path}",
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
            url: 'http://maps.googleapis.com/maps/api/staticmap?center=44.859348,+-0.565864&zoom=14&scale=2&size=382x382&maptype=roadmap&format=png&visual_refresh=true&markers=size:mid%7Ccolor:0xff0000%7Clabel:%7C44.859348,+-0.565864&markers=size:mid%7Ccolor:0xff0000%7Clabel:1%7C119+quai+des+Chartrons,+Bordeaux
'
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
