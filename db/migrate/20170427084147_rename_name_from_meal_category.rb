class RenameNameFromMealCategory < ActiveRecord::Migration[5.0]
  def change
    rename_column :meal_categories, :name, :name_ut
  end
end
