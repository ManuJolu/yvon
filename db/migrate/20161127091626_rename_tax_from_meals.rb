class RenameTaxFromMeals < ActiveRecord::Migration[5.0]
  def change
    rename_column :meals, :tax, :tax_rate
  end
end
