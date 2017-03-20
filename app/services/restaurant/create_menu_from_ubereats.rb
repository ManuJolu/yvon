class Restaurant::CreateMenuFromUbereats
  def initialize(restaurant)
    @restaurant = restaurant
  end

  def call
    begin
      return false unless restaurant.ubereats_url.present?
      html_file = RestClient.get(restaurant.ubereats_url)
      html_doc = Nokogiri::HTML(html_file)
      html_doc.css('div[class^="section_"] > div[class^="base_"]').each do |base|
        meal_category = restaurant.meal_categories.create(name: base.css('div[id^="subsection-"]').text.strip, timing: 'main_course')

        base.css('div[class^="content_"]').each do |content|
          meal_category.meals.create(
            name: content.css('div[class^="header_"]').text.strip,
            description: content.css('div[class^="description_"]').text.strip,
            price: content.css('div[class^="footer_"]').text.strip.match(/\d*\.\d*/)[0].to_f
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
