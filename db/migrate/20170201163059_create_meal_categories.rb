class CreateMealCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :meal_categories do |t|
      t.string :name
      t.references :restaurant, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
