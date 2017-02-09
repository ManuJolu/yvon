class AddRestaurantCategoryRefToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_reference :restaurants, :restaurant_category, foreign_key: true
  end
end
