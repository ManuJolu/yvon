class MealView
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
              title: 'Pick & Pay',
              payload: "meal_#{meal.id}_pay"
            },
            {
              type: 'postback',
              title: 'Pick & ➥ Menu',
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: "Pick & ➥ #{next_category.tr("_", " ").capitalize}",
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
              title: 'Pick & ➥ Menu',
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: 'Pick & Pay',
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

  def get_option(postback, options, params = {})
    options = options.map do |option|
      {
        type: 'postback',
        title: option.name.capitalize,
        payload: "meal_#{params[:meal_id]}_option_#{option.id}_#{params[:action]}"
      }
    end
    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: "Choose your option:",
          buttons: options
        }
      }
    )
  end
end
