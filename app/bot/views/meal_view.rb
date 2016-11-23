require 'cloudinary'

include CloudinaryHelper

class MealView
  def menu(postback, restaurant)
    elements = [
      {
        title: "#{restaurant.name}",
        image_url: "#{cl_image_path restaurant.photo.path, width: 382, height: 200, crop: :fill}",
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
              payload: "restaurant_#{restaurant.id}_category_starter"
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
              payload: "restaurant_#{restaurant.id}_category_main_course"
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
              payload: "restaurant_#{restaurant.id}_category_dessert"
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

  def index(postback, meals)
    meals = meals.map do |meal|
      {
        title: "#{meal.name}",
        image_url: "#{cl_image_path meal.photo.path, width: 382, height: 200, crop: :fill}",
        subtitle: "#{meal.description}\n#{meal.price.fdiv(100)} €",
        buttons: [
          {
            type: 'postback',
            title: 'Pay',
            payload: "meal_#{meal.id}_pay"
          },
          {
            type: 'postback',
            title: 'Menu',
            payload: "meal_#{meal.id}_menu"
          },
          {
            type: 'postback',
            title: 'Desserts',
            payload: "meal_#{meal.id}_next"
          }
        ]
      }
    end

    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: meals
        }
      }
    )
  end
end
