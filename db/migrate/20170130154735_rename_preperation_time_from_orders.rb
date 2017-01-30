class RenamePreperationTimeFromOrders < ActiveRecord::Migration[5.0]
  def change
        rename_column :orders, :preperation_time, :preparation_time
  end
end
