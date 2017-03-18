class RemoveRestaurantFromMeals < ActiveRecord::Migration[5.0]
  def change
    remove_reference :meals, :restaurant, index: true
  end
end
