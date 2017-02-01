class AddPositionToMeal < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :position, :integer
  end
end
