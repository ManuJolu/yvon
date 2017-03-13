class RenamePaidAtFromOrders < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :paid_at, :sent_at
  end
end
