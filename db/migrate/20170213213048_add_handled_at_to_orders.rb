class AddHandledAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :handled_at, :datetime
  end
end
