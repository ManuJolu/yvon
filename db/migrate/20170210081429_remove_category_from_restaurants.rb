class RemoveCategoryFromRestaurants < ActiveRecord::Migration[5.0]
  def change
    remove_column :restaurants, :category
  end
end
