class RenameNameInRestaurantCategory < ActiveRecord::Migration[5.0]
  def change
    rename_column :restaurant_categories, :name, :name_ut
  end
end
