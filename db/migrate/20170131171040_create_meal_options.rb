class CreateMealOptions < ActiveRecord::Migration[5.0]
  def change
    create_table :meal_options do |t|
      t.references :meal, foreign_key: true
      t.references :option, foreign_key: true

      t.timestamps
    end
  end
end
