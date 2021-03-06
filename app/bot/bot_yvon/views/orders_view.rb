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
    title = I18n.t('bot.order.cart.title', price: order.decorate.price)
    buttons = [
      {
        type: 'postback',
        title: I18n.t('bot.order.cart.add'),
        payload: "restaurant_#{order.restaurant.id}"
      }
    ]
    if order.table > 0
      title += I18n.t('bot.order.cart.table', table: order.table)
      # buttons << {
      #   type: 'postback',
      #   title: I18n.t('bot.order.cart.change_table'),
      #   payload: 'change_table'
      # }
    end

    elements = [
      {
        title: title,
        image_url: cl_image_path('cash_till.png', width: 382, height: 200, crop: :fill),
        # subtitle: I18n.t('bot.order.cart.subtitle'),
        buttons: buttons
      }
    ]
    elements += order.ordered_meals.by_meal_category.decorate.map do |ordered_meal|
      {
        title: ordered_meal,
        image_url: cl_image_path_with_second(ordered_meal.meal.photo&.path, ordered_meal.meal.meal_category.photo&.path, width: 382, height: 200, crop: :fill),
        subtitle: "#{ordered_meal.quantity} × #{ordered_meal.price}\n#{ordered_meal.meal.description}",
        buttons: [
          {
            type: 'postback',
            title: I18n.t('bot.order.cart.remove'),
            payload: "rm_ordered_meal_#{ordered_meal.id}"
          }
        ]
      }
    end

    message.reply(
      text: I18n.t('bot.order.cart.text')
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

    if order.table == 0
      ask_table
    else
      ask_payment_method(order)
    end
  end

  def ask_table
    message.reply(
      text: I18n.t('bot.order.cart.ask_table')
    )
  end

  def ask_payment_method(order)
    if user.stripe_customer_id.present?
      card_payment = I18n.t('bot.order.ask_payment_method.pay_card', last4: user.stripe_default_source_last4)
    else
      card_payment = I18n.t('bot.order.ask_payment_method.pay_no_card')
    end

    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.ask_payment_method.text'),
          buttons: [
            {
              type: 'postback',
              title: card_payment,
              payload: 'check_card'
            },
            # {
            #   type: 'postback',
            #   title: I18n.t('bot.order.ask_payment_method.pay_counter'),
            #   payload: 'check_counter'
            # },
            {
              type: 'postback',
              title: I18n.t('bot.order.ask_payment_method.demo'),
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
              title: I18n.t('bot.order.update_card.update_card'),
              url: user.decorate.show_url(protocol: 'https'),
              webview_height_ratio: 'tall',
              messenger_extensions: true,
              fallback_url: user.decorate.show_url,
              webview_share_button: 'hide'
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
              title: I18n.t('bot.order.update_card.update_card'),
              url: user.decorate.show_url(protocol: 'https'),
              webview_height_ratio: 'tall',
              messenger_extensions: true,
              fallback_url: user.decorate.show_url,
              webview_share_button: 'hide'
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

  def stripe_error(error_message)
    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "button",
          text: I18n.t('bot.order.stripe_error.message', error_message: error_message),
          buttons: [
            {
              type: 'postback',
              title: I18n.t('bot.order.stripe_error.update_card'),
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
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: I18n.t('bot.order.confirm.paid'),
            buttons: [{
              type: 'postback',
              title: I18n.t('bot.order.confirm.get_receipt'),
              payload: "order_#{order.id}_receipt",
            }]
          }
        }
      )
    elsif order.counter?
      message.reply(
        text: I18n.t('bot.order.confirm.password')
      )
    elsif order.demo?
      message.reply(
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: I18n.t('bot.order.confirm.demo'),
            buttons: [
              {
                type: 'element_share',
                share_contents: {
                  attachment: {
                    type: 'template',
                    payload: {
                      template_type: 'generic',
                      image_aspect_ratio: 'square',
                      elements: [
                        {
                          title: I18n.t('bot.order.share'),
                          image_url: cl_image_path("yvon_messenger_code.png", width: 400, crop: :scale),
                          buttons: [
                            {
                              type: 'web_url',
                              title: I18n.t('bot.shared_m_me'),
                              url: "http://m.me/HelloYvon?ref=shared"
                            }
                          ]
                        }
                      ]
                    }
                  }
                }
              },
              {
                type: 'postback',
                title: I18n.t('bot.order.confirm.get_receipt'),
                payload: "order_#{order.id}_receipt",
              }
            ]
          }
        }
      )
    end

    if order.table < 0
      message.reply(
        attachment: {
          type: 'template',
          payload: {
            template_type: 'button',
            text: I18n.t('bot.order.confirm.ready', preparation_time: order.preparation_time, ready_time: (order.sent_at + order.preparation_time.minutes).strftime('%H:%M')),
            buttons: [{
              type: 'web_url',
              title: I18n.t('bot.order.confirm.itinerary'),
              url: "http://maps.apple.com/maps?q=#{order.restaurant.address}",
              webview_height_ratio: 'tall'
            }]
          }
        }
      )
    end
  end

  def receipt(order)
    elements = order.ordered_meals.by_meal_category.map do |ordered_meal|
      {
        title: ordered_meal.meal.name,
        subtitle: "#{(ordered_meal.option.name + ' - ') if ordered_meal.option}#{ordered_meal.meal.description}",
        quantity: ordered_meal.quantity,
        price: ordered_meal.decorate.price_num,
        currency: "EUR",
        image_url: cl_image_path_with_second(ordered_meal.meal.photo&.path, ordered_meal.meal.meal_category.photo&.path, width: 100, height: 100, crop: :fill)
      }
    end

    if order.credit_card?
      payment_method = order.user.decorate.stripe_default_source_text
    else
      payment_method = I18n.t('bot.order.receipt.unknown_payment_method')
    end

    message.reply(
      attachment: {
        type: "template",
        payload: {
          template_type: "receipt",
          merchant_name: order.restaurant.name,
          recipient_name: "#{order.user.decorate.name}",
          order_number: "#{order.id}",
          currency: "EUR",
          payment_method: payment_method,
          timestamp: order.sent_at.to_i,
          elements: elements,
          summary: {
            subtotal: order.decorate.pretax_price_num,
            total_tax: order.decorate.tax_num,
            total_cost: order.decorate.price_num
          }
        }
      }
    )
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
              title: I18n.t('bot.order.menu_update_card.my_account'),
              url: user.decorate.show_url(protocol: 'https'),
              webview_height_ratio: 'tall',
              messenger_extensions: true,
              fallback_url: user.decorate.show_url,
              webview_share_button: 'hide'
            }
          ]
        }
      }
    )
  end

  private

  attr_reader :message, :user
end
