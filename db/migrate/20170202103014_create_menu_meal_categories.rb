class CreateMenuMealCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :menu_meal_categories do |t|
      t.references :menu, foreign_key: true
      t.references :meal_category, foreign_key: true
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
