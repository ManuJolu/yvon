class RenameFromMeal < ActiveRecord::Migration[5.0]
  def change
    rename_column :meals, :name, :name_ut
    rename_column :meals, :description, :description_ut
  end
end
