class AddMealCategoryReferenceToMeals < ActiveRecord::Migration[5.0]
  def change
    add_reference :meals, :meal_category, foreign_key: true
  end
end
