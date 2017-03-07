class RenameSloganFromRestaurants < ActiveRecord::Migration[5.0]
  def change
    rename_column :restaurants, :slogan, :about
  end
end
