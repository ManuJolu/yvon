class RestaurantsView
  def hello(message)
    message.reply(
      text: 'Hello!\nWhere can I help you find your restaurant?',
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def index(message, restaurants)
    if restaurants.present?
      elements = restaurants.map do |restaurant|
        {
          title: "#{restaurant.name}",
          # image_url: image_path 'logo.png',
          subtitle: "#{restaurant.description}",
          buttons: [
            {
              type: 'postback',
              title: 'Go',
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
        text: "Sorry, no restaurants near you..."
      )
    end
  end
end
