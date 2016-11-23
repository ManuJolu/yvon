require 'cloudinary'

include CloudinaryHelper

class MealView
  def menu(postback, restaurant)
    elements = [
      {
        title: "#{restaurant.name}",
        image_url: "#{cl_image_path restaurant.photo.path}",
        subtitle: "Carte du jour",
        default_action: {
          type: "web_url",
          url: "https://yvon.herokuapp.com/",
          messenger_extensions: true,
          webview_height_ratio: "tall",
          fallback_url: "https://yvon.herokuapp.com/"
        }
        # buttons: [
        #   {
        #       title: "View",
        #       type: "web_url",
        #       url: "https://fcatuhe.github.io/lewagon/",
        #       messenger_extensions: true,
        #       webview_height_ratio: "tall",
        #       fallback_url: "https://fcatuhe.github.io/lewagon/"
        #   }
        # ]
      },
      {
        title: "Starter",
        image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
        subtitle: "Restaurant starter message",
        buttons: [
          {
              title: "Open",
              type: "postback",
              payload: "category_0"
          }
        ]
      },
      {
        title: "Main course",
        image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
        subtitle: "Restaurant main course message",
        buttons: [
          {
              title: "Open",
              type: "postback",
              payload: "category_1"
          }
        ]
      },
      {
        title: "Dessert",
        image_url: "https://fcatuhe.github.io/lewagon/images/lewagon.png",
        subtitle: "Restaurant dessert message",
        buttons: [
          {
              title: "Open",
              type: "postback",
              payload: "category_2"
          }
        ]
      }
    ]

    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'list',
          elements: elements,
          buttons: [
            {
                title: "View more",
                type: "postback",
                payload: "more_restaurant_#{restaurant.id}"
            }
          ]
        }
      }
    )
  end

  def menu_more(postback, restaurant)
  end

  def index(postback, elements)
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: elements
        }
      }
    )
  end
end
