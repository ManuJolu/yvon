class AddPreperationTimeToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :preperation_time, :integer
  end
end
