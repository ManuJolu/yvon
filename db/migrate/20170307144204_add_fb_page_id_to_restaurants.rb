class AddFbPageIdToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :fb_page_id, :integer
  end
end
