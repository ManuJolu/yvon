class AddRatingToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :fb_overall_star_rating, :float
    add_column :restaurants, :fb_fan_count, :integer
    add_column :restaurants, :fb_rating_count, :integer
    add_column :restaurants, :fb_price_range, :string
  end
end
