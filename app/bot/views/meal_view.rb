class MealView
  def menu(postback, restaurant)
    elements = [
      {
        title: restaurant.name,
        image_url: cl_image_path(restaurant.photo.path, width: 382, height: 200, crop: :fill),
        subtitle: restaurant.description
        # buttons: [
        #   {
        #       title: "Pay",
        #       type: "postback",
        #       payload: "pay"
        #   }
        # ]
        # default_action: {
        #   type: "web_url",
        #   url: "#{restaurant.facebook_url}"
        # }
      },
      {
        title: "Starter",
        image_url: (cl_image_path(restaurant.meals.where(category: 'starter').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'starter').present?),
        subtitle: "#{('Suggestion: ' + restaurant.meals.where(category: 'starter').first.name) if restaurant.meals.where(category: 'starter').present?}",
        buttons: [
          {
              title: "➥ Starter",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_starter"
          }
        ]
      },
      {
        title: "Main course",
        image_url: (cl_image_path(restaurant.meals.where(category: 'main_course').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'main_course').present?),
        subtitle: "#{('Suggestion: ' + restaurant.meals.where(category: 'main_course').first.name) if restaurant.meals.where(category: 'main_course').present?}",
        buttons: [
          {
              title: "➥ Main course",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_main_course"
          }
        ]
      },
      {
        title: "Dessert",
        image_url: (cl_image_path(restaurant.meals.where(category: 'dessert').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'dessert').present?),
        subtitle: "#{('Suggestion: ' + restaurant.meals.where(category: 'dessert').first.name) if restaurant.meals.where(category: 'dessert').present?}",
        buttons: [
          {
              title: "➥ Dessert",
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
        elements = [
      {
        title: restaurant.name,
        image_url: cl_image_path(restaurant.photo.path, width: 382, height: 200, crop: :fill),
        subtitle: restaurant.description,
        buttons: [
          {
              title: "Pay",
              type: "postback",
              payload: "pay"
          }
        ]
      },
      {
        title: "Drink",
        image_url: (cl_image_path(restaurant.meals.where(category: 'drink').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'drink').present?),
        subtitle: "#{('Suggestion: ' + restaurant.meals.where(category: 'drink').first.name) if restaurant.meals.where(category: 'drink').present?}",
        buttons: [
          {
              title: "➥ Drink",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_drink"
          }
        ]
      }
    ]

    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'list',
          elements: elements
        }
      }
    )
  end

  def index(postback, meals, params = {})
    current_category = params[:current_category]
    next_category = params[:next_category]
    if next_category
      meals = meals.map do |meal|
        {
          title: meal.name,
          image_url: cl_image_path(meal.photo.path, width: 382, height: 200, crop: :fill),
          subtitle: "#{meal.description}\n#{meal.price}",
          buttons: [
            {
              type: 'postback',
              title: 'Order & Pay',
              payload: "meal_#{meal.id}_pay"
            },
            {
              type: 'postback',
              title: 'Order & ➥ Menu',
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: "Order & ➥ #{next_category.tr("_", " ").capitalize}",
              payload: "meal_#{meal.id}_next"
            }
          ]
        }
      end
      meals << {
        title: "No #{current_category.tr("_", " ")} for me",
        image_url: cl_image_path("v1480520365/no_thanks.png", width: 382, height: 200, crop: :fill),
        subtitle: "\nI'd better watch my figure",
        buttons: [
          {
            type: 'postback',
            title: 'Pay',
            payload: "pay"
          },
          {
            type: 'postback',
            title: '➥ Menu',
            payload: "menu"
          },
          {
            type: 'postback',
            title: "➥ #{next_category.tr("_", " ").capitalize}",
            payload: "category_#{next_category}"
          }
        ]
      }
    else
      meals = meals.map do |meal|
        {
          title: meal.name,
          image_url: cl_image_path(meal.photo.path, width: 382, height: 200, crop: :fill),
          subtitle: "#{meal.description}\n#{meal.price}",
          buttons: [
            {
              type: 'postback',
              title: 'Order & ➥ Menu',
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: 'Order & Pay',
              payload: "meal_#{meal.id}_pay"
            }
          ]
        }
      end
      meals << {
        title: "No #{current_category.tr("_", " ")} for me",
        image_url: cl_image_path("v1480520365/no_thanks.png", width: 382, height: 200, crop: :fill),
        subtitle: "\nI'd better watch my figure",
        buttons: [
          {
            type: 'postback',
            title: '➥ Menu',
            payload: "menu"
          },
          {
            type: 'postback',
            title: 'Pay',
            payload: "pay"
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

  def no_restaurant(postback)
    postback.reply(
      text: "Sorry, you have no restaurant selected. Can I help you find one?",
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end
end
