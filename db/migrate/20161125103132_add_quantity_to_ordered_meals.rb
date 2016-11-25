class AddQuantityToOrderedMeals < ActiveRecord::Migration[5.0]
  def change
    add_column :ordered_meals, :quantity, :integer
  end
end
