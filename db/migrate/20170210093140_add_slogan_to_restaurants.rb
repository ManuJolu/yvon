class AddSloganToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :slogan, :string
  end
end
