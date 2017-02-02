class AddPriceToMenu < ActiveRecord::Migration[5.0]
  def change
    add_monetize :menus, :price, currency: { present: false }
    add_column :menus, :tax_rate, :integer
  end
end
