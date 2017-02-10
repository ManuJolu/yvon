class EditPreparationTimeFromRestaurants < ActiveRecord::Migration[5.0]
  def change
    change_column :restaurants, :preparation_time, :integer, default: 15
  end
end
