class RenamePriceFromMeals < ActiveRecord::Migration[5.0]
  def change
    rename_column :meals, :price, :price_cents
  end
end
