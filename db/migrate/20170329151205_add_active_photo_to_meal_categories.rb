class AddActivePhotoToMealCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :meal_categories, :active, :boolean, default: true
    add_column :meal_categories, :photo, :string
  end
end
