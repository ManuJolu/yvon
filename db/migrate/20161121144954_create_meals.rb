class CreateMeals < ActiveRecord::Migration[5.0]
  def change
    create_table :meals do |t|
      t.references :restaurant, foreign_key: true
      t.integer :category
      t.string :name
      t.string :description
      t.integer :price
      t.integer :tax
      t.string :photo

      t.timestamps
    end
  end
end
