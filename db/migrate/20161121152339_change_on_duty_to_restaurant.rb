class ChangeOnDutyToRestaurant < ActiveRecord::Migration[5.0]
  def change
    change_column :restaurants, :on_duty, :boolean, default: false
  end
end
