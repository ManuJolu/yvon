require 'cloudinary'

include CloudinaryHelper

class RestaurantView
  def index(message, restaurants)
    if restaurants.present?
      elements = restaurants.map do |restaurant|
        {
          title: "#{restaurant.name}",
          image_url: "#{cl_image_path restaurant.photo.path}",
          subtitle: "#{restaurant.description}",
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
