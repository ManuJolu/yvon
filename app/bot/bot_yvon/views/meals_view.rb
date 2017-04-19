class BotYvon::MealsView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def index(meals, params = {})
    meals = meals.map do |meal|
      buttons = [
        {
          type: 'postback',
          title: I18n.t('bot.meal.index.pick'),
          payload: "meal_#{meal.id}"
        }
      ]
      result = {
        title: meal.name,
        image_url: cl_image_path_with_second(meal.photo&.path, meal.meal_category.photo&.path, width: 382, height: 200, crop: :fill),
        subtitle: "#{meal.price}\n#{meal.description}"
      }
      result[:buttons] = buttons if params[:on_duty]
      result
    end

    if params[:on_duty]
      meals << {
        title: I18n.t('bot.meal.index.no_thanks', meal_category: params[:meal_category].name.downcase),
        image_url: cl_image_path("background_white_382_200.png", overlay:"text:Fredoka%20One_40:#{I18n.t('bot.meal.index.no_thanks_image')}", color: "#292C3C"),
        subtitle: I18n.t('bot.meal.index.no_thanks_message'),
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.menu'),
            payload: "menu"
          }
        ]
      }
    else
      meals << {
        title: I18n.t('bot.meal.index.back'),
        image_url: cl_image_path("background_white_382_200.png", overlay:"text:Fredoka%20One_40:#{I18n.t('bot.meal.index.back_image')}", color: "#292C3C"),
        subtitle: I18n.t('bot.meal.index.back_message'),
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.meal.index.menu'),
            payload: "menu"
          }
        ]
      }
    end

    message.reply(
      text: I18n.t('bot.swipe', item: 'les plats')
    )

    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: meals
        }
      }
    )
  end

  def get_option(options, params = {})
    options = options.map do |option|
      {
        content_type: 'text',
        title: option.to_label.capitalize,
        payload: "meal_#{params[:meal_id]}_option_#{option.id}"
      }
    end
    message.reply(
      text: I18n.t('bot.meal.get_option.choose_option'),
      quick_replies: options
    )
  end

  private

  attr_reader :message, :user
end
