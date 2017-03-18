class BotYvon::RestaurantsView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def index(coordinates, restaurants)
    colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970', '0d644e', '9c3e9a', '364c59']
    url_array = [
      "http://maps.googleapis.com/maps/api/staticmap", # base
      "?center=#{coordinates[0]},+#{coordinates[1]}", # center
      # "&zoom=15", zoom
      "&scale=2", # scale
      "&size=382x382", # size
      "&maptype=roadmap&format=png&visual_refresh=true", # format
      "&key=#{ENV['GOOGLE_API_KEY']}", # key
      "&markers=size:mid%7Ccolor:0x#{colors[0]}%7Clabel:%7C#{coordinates[0]},#{coordinates[1]}" # user_marker
    ]

    elements = restaurants.map.with_index do |restaurant, i|
      url_array << "&markers=size:mid%7Ccolor:0x#{colors[(i + 1) % 8]}%7Clabel:#{i + 1}%7C#{restaurant.latitude},#{restaurant.longitude}"
      if restaurant.on_duty?
        title = "#{i + 1} - #{I18n.t('bot.restaurant.index.on_duty').upcase} - #{restaurant.name}"
      else
        title = "#{i + 1} - #{I18n.t('bot.restaurant.index.display_only').upcase} - #{restaurant.name}"
      end
      subtitle = ""
      subtitle += "#{restaurant.fb_overall_star_rating} #{restaurant.star_rating} - #{restaurant.fb_fan_count} fans\n" if restaurant.fb_overall_star_rating.present?
      subtitle += "#{restaurant.restaurant_category.name}\n#{restaurant.about}"
      {
        title: title,
        image_url: cl_image_path_with_default(restaurant.photo&.path, transformation: [
          { width: 382, height: 180, crop: :fill },
          { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
        ]),
        subtitle: subtitle,
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.restaurant.index.enter'),
            payload: "restaurant_#{restaurant.id}"
          }
        ]
      }
    end

    message.reply(
      attachment: {
        type: 'image',
        payload: {
          url: url_array.join
        }
      }
    )

    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: elements
        }
      }
    )
  end

  def show(restaurant, params = {})
    elements = []
    subtitle = ""
    subtitle += "#{restaurant.fb_overall_star_rating} #{restaurant.star_rating} - #{restaurant.fb_fan_count} fans\n" if restaurant.fb_overall_star_rating.present?
    subtitle += "#{restaurant.restaurant_category.name} - #{I18n.t('bot.restaurant.ready_in')} #{restaurant.preparation_time} min\n#{I18n.t('bot.restaurant.menu.swipe_right')}"
    element = {
      title: restaurant.name,
      image_url: cl_image_path_with_default(restaurant.photo&.path, width: 382, height: 200, crop: :fill),
      subtitle: subtitle
    }

    buttons = []
    back_button = {
      title: I18n.t('bot.restaurant.menu.back_to_map'),
      type: "postback",
      payload: "map"
    }
    order_button = {
      title: I18n.t('bot.restaurant.menu.order'),
      type: "postback",
      payload: "cart"
    }
    buttons << back_button unless params[:ordered_meals?]
    buttons << order_button if params[:ordered_meals?]
    element[:buttons] = buttons

    elements << element

    restaurant.meal_categories.limit(8).each do |meal_category|
      elements << {
        title: meal_category.name,
        image_url: (cl_image_path_with_default(restaurant.meals.are_active.find_by(meal_category: meal_category)&.photo&.path, width: 382, height: 200, crop: :fill) if restaurant.meals.are_active.find_by(meal_category: meal_category).present?),
        subtitle: "#{('Suggestion: ' + restaurant.meals.are_active.find_by(meal_category: meal_category).name) if restaurant.meals.are_active.find_by(meal_category: meal_category).present?}",
        buttons: [
          {
              title: "#{meal_category.name} ▷",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_#{meal_category.id}"
          }
        ]
      }
    end

    elements << {
      title: I18n.t('bot.restaurant.menu.display_menus'),
      image_url: cl_image_path("background.png", overlay:"text:Fredoka%20One_40:#{I18n.t('bot.restaurant.menu.menus_image')}", color: "#292C3C"),
      buttons: [
        {
            title: I18n.t('bot.restaurant.menu.menus'),
            type: "postback",
            payload: "restaurant_#{restaurant.id}_menus"
        }
      ]
    } if restaurant.menus.any?

    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: elements
        }
      }
    )
  end

  def menus(restaurant)
    text = ""
    text += restaurant.menus.decorate.join("\n")
    text += I18n.t('bot.restaurant.menu.menus_back')
    message.reply(
      text: text
    )
  end

  def user_restaurant_mismatch(restaurant_name)
    message.reply(
      text: I18n.t('bot.restaurant.restaurant_mismatch', restaurant_name: restaurant_name),
    )
  end

  def meal_user_restaurant_mismatch(restaurant_name)
    message.reply(
      text: I18n.t('bot.restaurant.meal_restaurant_mismatch', restaurant_name: restaurant_name),
    )
  end

  private

  attr_reader :message, :user
end
