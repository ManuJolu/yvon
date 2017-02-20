class RestaurantView
  def index(message, coordinates, restaurants)
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
      {
        title: "#{i + 1} - #{I18n.t('bot.restaurant.index.ready_in')} #{restaurant.preparation_time}min - #{restaurant.name}",
        item_url: restaurant.facebook_url,
        image_url: cl_image_path(restaurant.photo.path, transformation: [
          { width: 382, height: 180, crop: :fill },
          { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
        ]),
        subtitle: "#{(restaurant.distance_from(coordinates)*1000).round}m #{I18n.t('bot.restaurant.index.heading')} #{Geocoder::Calculations.compass_point(restaurant.bearing_from(coordinates))} - #{restaurant.restaurant_category.name}\n#{restaurant.slogan}",
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.restaurant.index.enter'),
            payload: "restaurant_#{restaurant.id}_page_0"
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

  def menu(postback, restaurant, params = {})
    elements = []
    element = {
      title: restaurant.name,
      image_url: cl_image_path(restaurant.photo.path, width: 382, height: 200, crop: :fill),
      subtitle: restaurant.slogan
    }
    buttons = [
      {
        title: I18n.t('bot.restaurant.menu.order'),
        type: "postback",
        payload: "cart"
      }
    ]
    element[:buttons] = buttons if params[:ordered_meals]
    elements << element

    start_index = params[:page] * 8
    end_index = start_index + 7
    restaurant.meal_categories[start_index..end_index].each do |meal_category|
      elements << {
        title: meal_category.name,
        image_url: (cl_image_path(restaurant.meals.is_active.where(meal_category: meal_category).first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.is_active.where(meal_category: meal_category).present?),
        subtitle: "#{('Suggestion: ' + restaurant.meals.is_active.where(meal_category: meal_category).first.name) if restaurant.meals.is_active.where(meal_category: meal_category).present?}",
        buttons: [
          {
              title: "➥ #{meal_category.name}",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_#{meal_category.id}"
          }
        ]
      }
    end

    # button = [
    #   {
    #       title: I18n.t('bot.restaurant.menu.view_more'),
    #       type: "postback",
    #       payload: "restaurant_#{restaurant.id}_page_#{params[:next_page]}"
    #   }
    # ] if params[:next_page]

    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: elements
          # buttons: button
        }
      }
    )

    if restaurant.menus.any? && params[:page] == 0
      text = I18n.t('bot.restaurant.menu.compute')
      text += restaurant.menus.decorate.join("\n")
      postback.reply(
        text: text
      )
    end
  end

  def restaurant_mismatch(postback, restaurant_name)
    postback.reply(
      text: I18n.t('bot.restaurant.restaurant_mismatch', restaurant_name: restaurant_name),
    )
  end

  def meal_restaurant_mismatch(postback, restaurant_name)
    postback.reply(
      text: I18n.t('bot.restaurant.meal_restaurant_mismatch', restaurant_name: restaurant_name),
    )
  end
end
