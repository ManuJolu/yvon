class EditQuantityDefaultOnOrderedMeals < ActiveRecord::Migration[5.0]
  def change
    change_column :ordered_meals, :quantity, :integer, default: 1
  end
end
