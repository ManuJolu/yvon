class CreateOrderElements < ActiveRecord::Migration[5.0]
  def change
    create_table :order_elements do |t|
      t.references :order, foreign_key: true
      t.references :element, polymorphic: true, index: true
      t.integer :quantity, default: 1

      t.timestamps
    end
  end
end
