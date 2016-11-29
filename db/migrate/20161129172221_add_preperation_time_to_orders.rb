class AddPreperationTimeToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :preperation_time, :integer
  end
end
