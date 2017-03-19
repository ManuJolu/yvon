class AddDefaultTaxRateToMeals < ActiveRecord::Migration[5.0]
  def change
    change_column :meals, :tax_rate, :integer, default: 0
    change_column :menus, :tax_rate, :integer, default: 0
  end
end
