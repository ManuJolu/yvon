class OrderView
  def no_meals(postback)
    postback.reply(
      text: "Sorry, you have no meals to order yet!"
    )
  end

  def restaurant_closed(postback, restaurant)
    postback.reply(
      text: "Woops, #{restaurant.name} has just closed... Can I help you find another restaurant?",
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def cart(postback, order, params = {})
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
          payment_method: "Visa #{rand(1000..9999)}",
          order_url: "http://www.hello-yvon.com",
          timestamp: params[:paid_at],
          elements: elements,
          address: {
            street_1: "Place de la Bourse",
            street_2: "",
            city: "Bordeaux",
            postal_code: "33000",
            state: "NA",
            country: "FR"
          },
          summary: {
            subtotal: order.pretax_price_num,
            total_tax: order.tax_num,
            total_cost: order.price_num
          }
          # adjustments: [
          #   {
          #     name: "New Customer Discount",
          #     amount: 20
          #   },
          #   {
          #     name: "$10 Off Coupon",
          #     amount: 10
          #   }
          # ]
        }
      }
    )

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
      text: "Your order will be ready in #{order.preparation_time}min at #{(Time.now + order.preparation_time.minutes).strftime('%-H:%M')}."
    )

    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [
            {
              title: "Go to #{order.restaurant.name}",
              image_url: url_array.join,
              item_url: "http://maps.apple.com/maps?q=#{order.restaurant.address}"
            }
          ]
        }
      }
    )
  end
end
