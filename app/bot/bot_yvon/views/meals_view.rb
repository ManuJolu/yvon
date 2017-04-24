class BotYvon::MealsView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def index(meals, params = {})
    meals = meals.map do |meal|
      price = meal.price
      price = I18n.t('bot.meal.index.starting_at', price: meal.options.first.price) if meal.price_cents == 0
      buttons = [
        {
          type: 'postback',
          title: I18n.t('bot.meal.index.pick'),
          payload: "meal_#{meal.id}"
        }
      ]
      result = {
        title: meal.name,
        image_url: cl_image_path_with_second(meal.photo&.path, params[:meal_category].photo&.path, width: 382, height: 200, crop: :fill),
        subtitle: "#{price}\n#{meal.description}"
      }
      result[:buttons] = buttons if params[:on_duty]
      result
    end

    if params[:on_duty]
      meals << {
        title: I18n.t('bot.meal.index.no_thanks', meal_category: params[:meal_category].name.downcase),
        image_url: cl_image_path("background_white_382_200.png", overlay:"text:Fredoka%20One_40:#{I18n.t('bot.meal.index.no_thanks_image')}", color: "#292C3C"),
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
      text: I18n.t('bot.swipe', item: 'la carte')
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
    if params[:meal].price_cents == 0
      options = options.map do |option|
        {
          content_type: 'text',
          title: "#{option.name.capitalize} : #{option.price}",
          payload: "meal_#{params[:meal].id}_option_#{option.id}"
        }
      end
    else
      options = options.map do |option|
        {
          content_type: 'text',
          title: option.to_label.capitalize,
          payload: "meal_#{params[:meal].id}_option_#{option.id}"
        }
      end
    end
    message.reply(
      text: I18n.t('bot.meal.get_option.choose_option'),
      quick_replies: options
    )
  end

  private

  attr_reader :message, :user
end
