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
          title: I18n.t('bot.meal.index.pick_menu'),
          payload: "meal_#{meal.id}_menu"
        }
      ]
      result = {
        title: meal.name,
        image_url: cl_image_path(meal.photo.path, width: 382, height: 200, crop: :fill),
        subtitle: "#{meal.description}\n#{meal.price}"
      }
      result[:buttons] = buttons if params[:order_acceptance]
      result
    end

    if params[:order_acceptance]
      meals << {
        title: I18n.t('bot.meal.index.no_thanks', meal_category: params[:meal_category].name.downcase),
        image_url: cl_image_path("no_thanks.png", width: 382, height: 200, crop: :fill),
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
        image_url: cl_image_path("back.png", width: 382, height: 200, crop: :fill),
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
        type: 'postback',
        title: option.name.capitalize,
        payload: "meal_#{params[:meal_id]}_option_#{option.id}_#{params[:action]}"
      }
    end
    message.reply(
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

  private

  attr_reader :message, :user
end
