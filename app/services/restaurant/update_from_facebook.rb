class Restaurant::UpdateFromFacebook
  def initialize(restaurant)
    @restaurant = restaurant
  end

  def call
    begin
      return false unless restaurant.fb_page_id.present? || restaurant.facebook_url.present?
      page_ref = restaurant.fb_page_id
      unless page_ref
        /https:\/\/www.facebook.com\/(?<page_name>.*-(?<page_id>\d+)|.*)\// =~ restaurant.facebook_url
        page_ref = page_id.present? ? page_id : page_name
      end
      p page_ref
      p "https://graph.facebook.com/v2.8/#{page_ref}?fields=name,about,description,price_range,fan_count,overall_star_rating,rating_count,location&access_token=#{restaurant.user.token}"

      restaurant_data_json = RestClient.get("https://graph.facebook.com/v2.8/#{page_ref}?fields=name,about,description,price_range,fan_count,overall_star_rating,rating_count,location&access_token=#{restaurant.user.token}")
      p restaurant_data_json
      restaurant_data = JSON.parse restaurant_data_json
      p restaurant_data
      restaurant.fb_page_id = restaurant_data['id']
      restaurant.name ||= restaurant_data['name']
      restaurant.about = restaurant_data['about'] || restaurant_data['description'] || restaurant_data['name']
      restaurant.description = restaurant_data['description']
      restaurant.fb_price_range = restaurant_data['price_range']
      restaurant.fb_fan_count = restaurant_data['fan_count']
      restaurant.fb_overall_star_rating = restaurant_data['overall_star_rating']
      restaurant.fb_rating_count = restaurant_data['rating_count']
      restaurant.address ||= "#{restaurant_data['location']['street']}, #{restaurant_data['location']['zip']} #{restaurant_data['location']['city']}, #{restaurant_data['location']['country']}"
      p restaurant.valid?
      p restaurant.errors
      return false unless restaurant.save

      restaurant_picture_data_json = RestClient.get("https://graph.facebook.com/v2.8/#{page_ref}/picture?width=480&redirect=0&access_token=#{restaurant.user.token}")
      restaurant_picture_data = JSON.parse restaurant_picture_data_json
      p restaurant_picture_data
      restaurant.photo_url = restaurant_picture_data['data']['url']
      p restaurant
      true
    rescue
      false
    end
  end

  private

  attr_accessor :restaurant
end
