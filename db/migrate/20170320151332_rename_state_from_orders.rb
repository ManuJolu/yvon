class RenameStateFromOrders < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :state, :payment_method
  end
end
