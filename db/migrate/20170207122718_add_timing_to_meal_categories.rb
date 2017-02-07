class AddTimingToMealCategories < ActiveRecord::Migration[5.0]
  def change
    add_column :meal_categories, :timing, :integer, default: 1
  end
end
