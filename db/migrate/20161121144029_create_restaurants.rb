class CreateRestaurants < ActiveRecord::Migration[5.0]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.string :address
      t.integer :category, default: 0
      t.boolean :on_duty
      t.string :shift
      t.string :description
      t.string :photo
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
