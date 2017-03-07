class ChangeIntegerLimitInRestaurants < ActiveRecord::Migration[5.0]
  def change
    change_column :restaurants, :fb_page_id, :integer, limit: 8
  end
end
