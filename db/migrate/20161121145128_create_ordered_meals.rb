class CreateOrderedMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :ordered_meals do |t|
      t.references :order, foreign_key: true
      t.references :meal, foreign_key: true

      t.timestamps
    end
  end
end
