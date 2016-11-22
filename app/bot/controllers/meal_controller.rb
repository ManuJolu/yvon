class MealController
  def initialize
    @view = MealView.new
  end

  def menu(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu(postback, restaurant)
  end

  def menu_more(postback, params = {})
    restaurant = Restaurant.find(params[:restaurant_id])
    @view.menu_more(postback, restaurant)
  end

  def index(postback, params = {})
    elements = []
    4.times do |i|
      elements << {
        title: "Plat #{i}",
        image_url: 'http://www.formation-pizza-marketing.com/wp-content/uploads/2014/01/pizza-malbouffe-plat-equilibre2.jpg',
        subtitle: "Description plat #{i}\nOrder and:",
        buttons: [
          {
            type: 'postback',
            title: 'Pay',
            payload: "meal_#{i}"
          },
          {
            type: 'postback',
            title: 'Menu',
            payload: "meal_#{i}"
          },
          {
            type: 'postback',
            title: 'Desserts',
            payload: "meal_#{i}"
          }
        ]
      }
    end
    @view.index(postback, elements)
  end
end
