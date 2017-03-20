class Restaurant::CreateMenuFromDeliveroo
  def initialize(restaurant)
    @restaurant = restaurant
  end

  def call
    begin
      return false unless restaurant.deliveroo_url.present?
      html_file = RestClient.get(restaurant.deliveroo_url)
      html_doc = Nokogiri::HTML(html_file)

      html_doc.css('.results-group').each do |results_group|
        meal_category = restaurant.meal_categories.create(name: results_group.css('h3').text.strip, timing: 'main_course')
        results_group.css('.menu-item').each do |menu_item|
          meal_category.meals.create(
            name: menu_item.css('.list-item-title').text.strip,
            description: menu_item.css('.list-item-description').text.strip,
            price: menu_item.css('.item-price').text.strip.gsub(',', '.').to_f
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
