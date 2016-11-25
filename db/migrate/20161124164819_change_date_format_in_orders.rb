class ChangeDateFormatInOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :paid_at, :datetime
    change_column :orders, :ready_at, :datetime
  end
end
