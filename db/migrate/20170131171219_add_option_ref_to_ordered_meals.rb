class AddOptionRefToOrderedMeals < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordered_meals, :option, foreign_key: true
  end
end
