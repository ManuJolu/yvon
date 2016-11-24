class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :orders, :start_at, :paid_at
    rename_column :orders, :finish_at, :ready_at
    add_column :orders, :delivered_at, :date
  end
end
