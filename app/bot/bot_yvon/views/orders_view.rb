class BotYvon::OrdersView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def no_meals
    message.reply(
      text: I18n.t('bot.order.no_meals')
    )
  end

  def restaurant_closed(restaurant)
    message.reply(
      text: I18n.t('bot.order.restaurant_closed', restaurant_name: restaurant.name),
      quick_replies: [
        {
          content_type: 'location'
        }
      ]
    )
  end

  def cart(order)
    elements = order.ordered_meals.by_meal_category.map do |ordered_meal|
      {
        title: ordered_meal.meal.name,
        subtitle: "#{(ordered_meal.option.name + ' - ') if ordered_meal.option}#{ordered_meal.meal.description}",
        quantity: ordered_meal.quantity,
        price: ordered_meal.meal.decorate.price_num,
        currency: "EUR",
        image_url: cl_image_path_with_default(ordered_meal.meal.photo&.path, width: 100, height: 100, crop: :fill)
      }
    end

    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "receipt",
          recipient_name: "#{order.user.decorate.name}",
          order_number: "#{order.id}",
          currency: "EUR",
          payment_method: I18n.t('bot.order.cart.order_pending'),
          timestamp: Time.now.to_i,
          elements: elements,
          summary: {
            subtotal: order.decorate.pretax_price_num,
            total_tax: order.decorate.tax_num,
            total_cost: order.decorate.price_num
          },
          adjustments: [
            {
              name: I18n.t('bot.order.cart.discounts'),
              amount: order.decorate.discount_num
            }
            # {
            #   name: "Welcome coupon",
            #   amount: 5
            # }
          ]
        }
      }
    )

    if order.user.stripe_customer_id.present?
      card_payment = I18n.t('bot.order.cart.pay_card', last4: order.user.stripe_default_source_last4)
    else
      card_payment = I18n.t('bot.order.cart.pay_no_card')
    end

    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.cart.ask_payment_method'),
          buttons: [
            {
              type: 'postback',
              title: card_payment,
              payload: 'check_card'
            },
            {
              type: 'postback',
              title: I18n.t('bot.order.cart.pay_counter'),
              payload: 'check_counter'
            },
            {
              type: 'postback',
              title: I18n.t('bot.order.cart.demo'),
              payload: 'demo'
            }
          ]
        }
      }
    )
  end

  def update_card
    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.update_card.no_card'),
          buttons: [
            {
              type: 'web_url',
              url: user.decorate.show_url,
              title: I18n.t('bot.order.update_card.update_card'),
              webview_height_ratio: 'tall',
              webview_share_button: 'hide',
              messenger_extensions: true,
              fallback_url: 'http://www.hello-yvon.com/'
            },
            {
              type: 'postback',
              title: I18n.t('bot.order.update_card.pay'),
              payload: 'check_card'
            }
          ]
        }
      }
    )
  end

  def update_card_counter
    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.update_card_counter.no_card'),
          buttons: [
            {
              type: 'web_url',
              url: user.decorate.show_url,
              title: I18n.t('bot.order.update_card.update_card'),
              webview_height_ratio: 'tall',
              webview_share_button: 'hide',
              messenger_extensions: true,
              fallback_url: 'http://www.hello-yvon.com/'
            },
            {
              type: 'postback',
              title: I18n.t('bot.order.update_card_counter.pay'),
              payload: 'check_counter'
            }
          ]
        }
      }
    )
  end

  def card_error(error_message)
    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.card_error.message', error_message: error_message),
          buttons: [
            {
              type: 'postback',
              title: I18n.t('bot.order.card_error.update_card'),
              payload: 'update_card'
            }
          ]
        }
      }
    )
  end

  def confirm(order)
    if order.credit_card?
      message.reply(
        text: I18n.t('bot.order.confirm.paid')
      )
    elsif order.counter?
      message.reply(
        text: I18n.t('bot.order.confirm.password')
      )
    elsif order.demo?
      message.reply(
        text: I18n.t('bot.order.confirm.demo')
      )
    end

    message.reply(
      text: I18n.t('bot.order.confirm.ready', preparation_time: order.preparation_time, ready_time: (order.sent_at + order.preparation_time.minutes).strftime('%H:%M'))
    )

    # colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970', '0d644e', '9c3e9a', '364c59']
    # url_array = [
    #   "http://maps.googleapis.com/maps/api/staticmap", # base
    #   "?center=#{order.restaurant.latitude},+#{order.restaurant.longitude}", # center
    #   # "&zoom=15", zoom
    #   "&scale=2", # scale
    #   "&size=382x382", # size
    #   "&maptype=roadmap&format=png&visual_refresh=true", # format
    #   "&key=#{ENV['GOOGLE_API_KEY']}", # key
    #   # "&markers=size:mid%7Ccolor:0x#{colors[0]}%7Clabel:%7C#{coordinates[0]},#{coordinates[1]}", # user_marker
    #   "&markers=size:mid%7Ccolor:0x#{colors[3]}%7Clabel:%7C#{order.restaurant.latitude},#{order.restaurant.longitude}"
    # ]
    # message.reply(
    #   attachment: {
    #     type: "template",
    #     payload: {
    #       template_type: "generic",
    #       elements: [
    #         {
    #           title: I18n.t('bot.order.confirm.go_to', restaurant_name: order.restaurant.name),
    #           image_url: url_array.join,
    #           item_url: "http://maps.apple.com/maps?q=#{order.restaurant.address}"
    #         }
    #       ]
    #     }
    #   }
    # )
  end

  def menu_update_card
    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.menu_update_card.go_to_account'),
          buttons: [
            {
              type: 'web_url',
              url: user.decorate.show_url,
              title: I18n.t('bot.order.menu_update_card.my_account'),
              webview_height_ratio: 'tall',
              webview_share_button: 'hide',
              messenger_extensions: true,
              fallback_url: 'http://www.hello-yvon.com/'
            }
          ]
        }
      }
    )
  end

  private

  attr_reader :message, :user
end
