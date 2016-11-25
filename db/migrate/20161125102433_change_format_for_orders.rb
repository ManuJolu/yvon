class ChangeFormatForOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :delivered_at, :datetime
  end
end
