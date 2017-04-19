class BotYvon::RestaurantsView
  def initialize(message, user)
    @message = message
    @user = user
  end

  def index(coordinates, restaurants)
    colors = ['CC0000', 'FF69B4', 'FFC161', '48D1CC', '191970', '0d644e', '9c3e9a', '364c59', 'F8F4E3', 'FF8966']
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
      if restaurant.active? || restaurant.displayable?
        if restaurant.displayable?
          title = "#{i + 1} - #{I18n.t('bot.restaurant.index.displayable').upcase} - #{restaurant.name}"
        elsif restaurant.on_duty?
          title = "#{i + 1} - #{I18n.t('bot.restaurant.index.on_duty').upcase} #{I18n.t('bot.restaurant.ready_in')} #{restaurant.preparation_time}min - #{restaurant.name}"
        else
          title = "#{i + 1} - #{I18n.t('bot.restaurant.index.off_duty').upcase} - #{restaurant.name}"
        end
        subtitle = ""
        subtitle += "#{restaurant.fb_overall_star_rating} #{restaurant.star_rating} - #{restaurant.fb_fan_count} fans\n" if restaurant.fb_overall_star_rating.present?
        subtitle += "#{restaurant.restaurant_category.name}\n#{restaurant.about}"
        buttons = [
          {
          type: 'postback',
          title: I18n.t('bot.restaurant.index.enter'),
          payload: "restaurant_#{restaurant.id}"
          }
        ]
      elsif restaurant.votable?
          title = "#{i + 1} - #{I18n.t('bot.restaurant.index.votable').upcase} - #{restaurant.name}"
          subtitle = ""
          subtitle += "#{restaurant.fb_overall_star_rating} #{restaurant.star_rating} - #{restaurant.fb_fan_count} fans\n" if restaurant.fb_overall_star_rating.present?
        if user.voted_for?(restaurant)
          subtitle += I18n.t('bot.restaurant.index.votes', count: restaurant.get_upvotes.sum(:vote_weight))
          subtitle += I18n.t('bot.restaurant.index.vote_share')
          buttons = [
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
                        title: I18n.t('bot.restaurant.upvote.share', restaurant: restaurant.name),
                        image_url: cl_image_path_with_default(restaurant.photo&.path, width: 400, height: 400, crop: :fill),
                        buttons: [
                          {
                            type: 'web_url',
                            title: "Hello Yvon",
                            url: "http://m.me/HelloYvon?ref=shared_vote"
                          }
                        ]
                      }
                    ]
                  }
                }
              }
            }
          ]
        else
          subtitle += I18n.t('bot.restaurant.index.vote_invitation')
          subtitle += I18n.t('bot.restaurant.index.votes', count: restaurant.get_upvotes.sum(:vote_weight))
          buttons = [
            {
              type: 'postback',
              title: I18n.t('bot.restaurant.index.upvote'),
              payload: "restaurant_#{restaurant.id}_upvote"
            }
          ]
        end
      end

      {
        title: title,
        image_url: cl_image_path_with_default(restaurant.photo&.path, transformation: [
          { width: 382, height: 180, crop: :fill },
          { overlay: 'one_pixel.png', effect: :colorize, color: "rgb:#{colors[(i + 1) % 8]}", width: 382, height: 20, y: -100 }
        ]),
        subtitle: subtitle,
        buttons: buttons
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
      text: I18n.t('bot.swipe', item: 'les restaurants')
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

    restaurant.meal_categories.are_active.limit(9).each do |meal_category|
      elements << {
        title: meal_category.name,
        image_url: cl_image_path_with_second(meal_category.meals.are_active.first&.photo&.path, meal_category.photo&.path, width: 382, height: 200, crop: :fill),
        subtitle: "#{('Suggestion: ' + meal_category.meals.are_active.first.name) if meal_category.meals.are_active.any?}",
        buttons: [
          {
              title: "#{meal_category.name} ▷",
              type: "postback",
              payload: "meal_category_#{meal_category.id}"
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
          elements: elements
        }
      }
    )
  end

  def upvote(restaurant)
    message.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'button',
          text: I18n.t('bot.restaurant.upvote.text', restaurant: restaurant.name),
          buttons: [
            {
              title: I18n.t('bot.restaurant.menu.back_to_map'),
              type: "postback",
              payload: "map"
            },
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
                        title: I18n.t('bot.restaurant.upvote.share', restaurant: restaurant.name),
                        image_url: cl_image_path_with_default(restaurant.photo&.path, width: 400, height: 400, crop: :fill),
                        buttons: [
                          {
                            type: 'web_url',
                            title: "Hello Yvon",
                            url: "http://m.me/HelloYvon?ref=shared_vote"
                          }
                        ]
                      }
                    ]
                  }
                }
              }
            }
          ]
        }
      }
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
