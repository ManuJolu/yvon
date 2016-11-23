class AddFacebookUrlToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :facebook_url, :string
  end
end
