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
        title: "#{i + 1} - ready in #{restaurant.preparation_time}min - #{restaurant.name}",
        item_url: restaurant.facebook_url,
        image_url: cl_image_path(restaurant.photo.path, transformation: [
          { width: 382, height: 180, crop: :fill },
          { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
        ]),
        subtitle: "#{(restaurant.distance_from(coordinates)*1000).round}m heading #{Geocoder::Calculations.compass_point(restaurant.bearing_from(coordinates))} - #{restaurant.category.capitalize} food\n#{restaurant.description}",
        buttons: [
          {
            type: 'postback',
            title: 'Enter',
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

  def restaurant_mismatch(postback, restaurant_name)
    postback.reply(
      text: "Sorry, this menu belongs to #{restaurant_name}, here is the right menu:",
    )
  end

  def meal_restaurant_mismatch(postback, restaurant_name)
    postback.reply(
      text: "Sorry, this meal belongs to #{restaurant_name}, here is the right menu:",
    )
  end
end
