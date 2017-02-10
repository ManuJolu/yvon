class MealView
  def index(postback, meals, params = {})
    current_meal_category = params[:current_meal_category]
    next_meal_category = params[:next_meal_category]
    if next_meal_category
      meals = meals.map do |meal|
        {
          title: meal.name,
          image_url: cl_image_path(meal.photo.path, width: 382, height: 200, crop: :fill),
          subtitle: "#{meal.description}\n#{meal.price}",
          buttons: [
            {
              type: 'postback',
              title: I18n.t('bot.meal.index.pick_pay'),
              payload: "meal_#{meal.id}_pay"
            },
            {
              type: 'postback',
              title: I18n.t('bot.meal.index.pick_menu'),
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: I18n.t('bot.meal.index.pick_next', next_category: next_meal_category.name),
              payload: "meal_#{meal.id}_next"
            }
          ]
        }
      end
      meals << {
        title: I18n.t('bot.meal.index.no_thanks', current_category: current_meal_category.name.downcase),
        image_url: cl_image_path("v1480520365/no_thanks.png", width: 382, height: 200, crop: :fill),
        subtitle: I18n.t('bot.meal.index.no_thanks_message'),
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.pay'),
            payload: "pay"
          },
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.menu'),
            payload: "menu"
          },
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.next', next_category: next_meal_category.name),
            payload: "category_#{next_meal_category.id}"
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
              title: I18n.t('bot.meal.index.pick_menu'),
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: I18n.t('bot.meal.index.pick_pay'),
              payload: "meal_#{meal.id}_pay"
            }
          ]
        }
      end
      meals << {
        title: I18n.t('bot.meal.index.no_thanks', current_category: current_meal_category.name.downcase),
        image_url: cl_image_path("v1480520365/no_thanks.png", width: 382, height: 200, crop: :fill),
        subtitle: I18n.t('bot.meal.index.no_thanks_message'),
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.menu'),
            payload: "menu"
          },
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.pay'),
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
          text: I18n.t('bot.meal.get_option.choose_option'),
          buttons: options
        }
      }
    )
  end
end
