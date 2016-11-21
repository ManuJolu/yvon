class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :restaurant, foreign_key: true
      t.integer :user_rating
      t.string :user_comment
      t.date :start_at
      t.date :finish_at

      t.timestamps
    end
  end
end
