class AddActiveToMeal < ActiveRecord::Migration[5.0]
  def change
    add_column :meals, :active, :boolean, default: true
  end
end
