class ChangeDefaultPriceFromMenus < ActiveRecord::Migration[5.0]
  def change
    change_column_default :menus, :price_cents, nil
  end
end
