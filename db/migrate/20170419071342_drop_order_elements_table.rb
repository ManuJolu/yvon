class DropOrderElementsTable < ActiveRecord::Migration[5.0]
  def up
    drop_table :order_elements
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
