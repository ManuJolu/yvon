class ChangeTimingFromMealCategories < ActiveRecord::Migration[5.0]
  def change
    change_column_default :meal_categories, :timing, nil
  end
end
