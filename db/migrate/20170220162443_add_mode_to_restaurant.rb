class AddModeToRestaurant < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :mode, :integer, default: 0
  end
end
