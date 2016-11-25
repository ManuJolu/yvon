class OrderView
  def cart(postback, order)
    elements = order.ordered_meals.map do |ordered_meal|
      {
        title: ordered_meal.meal.name,
        subtitle: ordered_meal.meal.description,
        quantity: ordered_meal.quantity,
        price: format("%.2f", ordered_meal.meal.price.fdiv(100)),
        currency: "EUR",
        image_url: cl_image_path(ordered_meal.meal.photo.path, width: 100, height: 100, crop: :fill)
      }
    end

    postback.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "receipt",
          recipient_name: "#{order.user.first_name} #{order.user.last_name}",
          order_number: "#{order.id}",
          currency: "EUR",
          payment_method: "Visa #{rand(1000..9999)}",
          order_url: "https://yvon.herokuapp.com",
          timestamp: "#{order.paid_at.to_i}",
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
            subtotal: format("%.2f", order.subtotal.fdiv(100)),
            total_tax: format("%.2f", order.total_tax.fdiv(100)),
            total_cost: format("%.2f", order.total_cost.fdiv(100))
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

    colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970']
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
      attachment: {
        type: "template",
        payload: {
          template_type: "generic",
          elements: [
            {
              title: "Go to #{order.restaurant.name}",
              image_url: url_array.join,
              item_url: "http://maps.apple.com/maps?q=#{order.restaurant.latitude},#{order.restaurant.longitude}"
            }
          ]
        }
      }
    )
  end
end
