class OrderView
  def no_meals(postback)
    postback.reply(
      text: I18n.t('bot.order.no_meals')
    )
  end

  def restaurant_closed(postback, restaurant)
    postback.reply(
      text: I18n.t('bot.order.restaurant_closed', restaurant_name: restaurant.name),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def cart(postback, order)
    elements = order.ordered_meals.map do |ordered_meal|
      {
        title: ordered_meal.meal.name,
        subtitle: "#{(ordered_meal.option.name + ' - ') if ordered_meal.option}#{ordered_meal.meal.description}",
        quantity: ordered_meal.quantity,
        price: ordered_meal.meal.price_num,
        currency: "EUR",
        image_url: cl_image_path(ordered_meal.meal.photo.path, width: 100, height: 100, crop: :fill)
      }
    end

    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "receipt",
          recipient_name: "#{order.user.name}",
          order_number: "#{order.id}",
          currency: "EUR",
          payment_method: I18n.t('bot.order.cart.payment_method'),
          order_url: "http://www.hello-yvon.com",
          timestamp: Time.now.to_i,
          elements: elements,
          address: {
            street_1: "Quai de Bacalan",
            street_2: "",
            city: "Bordeaux",
            postal_code: "33300",
            state: "NA",
            country: "FR"
          },
          summary: {
            subtotal: order.pretax_price_num,
            total_tax: order.tax_num,
            total_cost: order.price_num
          },
          adjustments: [
            {
              name: I18n.t('bot.order.cart.discounts'),
              amount: order.discount_num
            }
            # {
            #   name: "Welcome coupon",
            #   amount: 5
            # }
          ]
        }
      }
    )

    postback.reply(
      text: I18n.t('bot.order.cart.beta_code'),
      quick_replies: [
        {
          content_type: 'text',
          title: I18n.t('bot.order.cart.demo'),
          payload: 'demo'
        }
      ]
    )

  end

  def confirm(postback, order, params = {})
    colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970', '0d644e', '9c3e9a', '364c59']
    url_array = [
      "http://maps.googleapis.com/maps/api/staticmap", # base
      "?center=#{order.restaurant.latitude},+#{order.restaurant.longitude}", # center
      # "&zoom=15", zoom
      "&scale=2", # scale
      "&size=382x382", # size
      "&maptype=roadmap&format=png&visual_refresh=true", # format
      "&key=#{ENV['GOOGLE_API_KEY']}", # key
      # "&markers=size:mid%7Ccolor:0x#{colors[0]}%7Clabel:%7C#{coordinates[0]},#{coordinates[1]}", # user_marker
      "&markers=size:mid%7Ccolor:0x#{colors[3]}%7Clabel:%7C#{order.restaurant.latitude},#{order.restaurant.longitude}"
    ]

    postback.reply(
      text: I18n.t('bot.order.cart.ready', preparation_time: order.preparation_time, ready_time: (Time.now + order.preparation_time.minutes).strftime('%-H:%M'))
    )

    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [
            {
              title: I18n.t('bot.order.cart.go_to', restaurant_name: order.restaurant.name),
              image_url: url_array.join,
              item_url: "http://maps.apple.com/maps?q=#{order.restaurant.address}"
            }
          ]
        }
      }
    )
  end

  def notify_ready(order)
    Facebook::Messenger::Bot.deliver({
      recipient: {
        id: order.user.messenger_id
      },
      message: {
        text: I18n.t('bot.order.notify_ready', user_first_name: order.user.first_name,restaurant_name: order.restaurant.name)
      }},
      access_token: ENV['ACCESS_TOKEN']
    )
  end

  def notify_delivered(order)
    Facebook::Messenger::Bot.deliver({
      recipient: {
        id: order.user.messenger_id
      },
      message: {
        text: I18n.t('bot.order.notify_delivered', user_first_name: order.user.first_name,restaurant_name: order.restaurant.name),
        quick_replies: [
          {
            content_type: 'location'
          }
        ]
      }},
      access_token: ENV['ACCESS_TOKEN']
    )
  end
end
