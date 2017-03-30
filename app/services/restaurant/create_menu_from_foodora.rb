class Restaurant::CreateMenuFromFoodora
  def initialize(restaurant)
    @restaurant = restaurant
  end

  def call
    begin
      return false unless restaurant.foodora_url.present?
      html_file = RestClient.get(restaurant.foodora_url)
      html_doc = Nokogiri::HTML(html_file)
      menu_items = html_doc.css('.menu__items').children

      meal_category = nil

      menu_items.each do |menu_item|
        if menu_item.attributes["class"]&.value == "menu__items__title"
          puts menu_item.text.strip
          meal_category = restaurant.meal_categories.create(name: menu_item.text.strip, timing: 'main_course')
        elsif menu_item.attributes["class"]&.value == "menu__item"
          meal_category.meals.create(
            name: menu_item.css('.menu__item__name').text.strip,
            description: menu_item.css('.menu__item__description').text.strip,
            price: menu_item.css('.menu__item__price').text.strip.gsub(',', '.').match(/\d*\.\d*/)[0].to_f
          )
        end
      end
      true
    rescue
      false
    end
  end

  private

  attr_accessor :restaurant
end
