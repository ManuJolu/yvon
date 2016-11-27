class AddLocatedAtToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :located_at, :datetime
  end
end
