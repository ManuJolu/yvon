class RemoveCategoryFromMeals < ActiveRecord::Migration[5.0]
  def change
    remove_column :meals, :category
  end
end
