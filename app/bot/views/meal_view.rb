require 'cloudinary'

include CloudinaryHelper

class MealView
  def menu(postback, restaurant)
    elements = [
      {
        title: "#{restaurant.name}",
        image_url: "#{cl_image_path restaurant.photo.path, width: 382, height: 200, crop: :fill}",
        subtitle: "Carte du jour",
        default_action: {
          type: "web_url",
          url: "#{restaurant.facebook_url}"
        }
      },
      {
        title: "Starter",
        image_url: "#{cl_image_path(restaurant.meals.where(category: 'starter').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'starter').present?}",
        subtitle: "e.g. #{restaurant.meals.where(category: 'starter').first.name if restaurant.meals.where(category: 'starter').present?}",
        buttons: [
          {
              title: "Open",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_starter"
          }
        ]
      },
      {
        title: "Main course",
        image_url: "#{cl_image_path(restaurant.meals.where(category: 'main_course').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'main_course').present?}",
        subtitle: "e.g. #{restaurant.meals.where(category: 'main_course').first.name if restaurant.meals.where(category: 'main_course').present?}",
        buttons: [
          {
              title: "Open",
              type: "postback",
              payload: "restaurant_#{restaurant.id}_category_main_course"
          }
        ]
      },
      {
        title: "Dessert",
        image_url: "#{cl_image_path(restaurant.meals.where(category: 'dessert').first&.photo&.path, width: 100, height: 100, crop: :fill) if restaurant.meals.where(category: 'dessert').present?}",
        subtitle: "e.g. #{restaurant.meals.where(category: 'dessert').first.name if restaurant.meals.where(category: 'dessert').present?}",
        buttons: [
          {
              title: "Open",
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
  end

  def index(postback, meals, params = {})
    next_category = params[:next_category]
    if next_category
      meals = meals.map do |meal|
        {
          title: "#{meal.name}",
          image_url: "#{cl_image_path meal.photo.path, width: 382, height: 200, crop: :fill}",
          subtitle: "#{meal.description}\n#{format("%.2f", meal.price.fdiv(100))} €\nORDER and:",
          buttons: [
            {
              type: 'postback',
              title: 'Pay',
              payload: "meal_#{meal.id}_pay"
            },
            {
              type: 'postback',
              title: 'Menu',
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: "#{next_category.tr("_", " ")}",
              payload: "meal_#{meal.id}_next"
            }
          ]
        }
      end
    else
      meals = meals.map do |meal|
        {
          title: "#{meal.name}",
          image_url: "#{cl_image_path meal.photo.path, width: 382, height: 200, crop: :fill}",
          subtitle: "#{meal.description}\n#{meal.price.fdiv(100)} €",
          buttons: [
            {
              type: 'postback',
              title: 'Menu',
              payload: "meal_#{meal.id}_menu"
            },
            {
              type: 'postback',
              title: 'Pay',
              payload: "meal_#{meal.id}_pay"
            }
          ]
        }
      end
    end

    postback.reply(
      attachment: {
        type: 'template',
        payload: {
          template_type: 'generic',
          elements: meals
        }
      }
    )
  end
end
