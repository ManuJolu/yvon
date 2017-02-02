class RenamePreperationTimeFromRestaurants < ActiveRecord::Migration[5.0]
  def change
    rename_column :restaurants, :preperation_time, :preparation_time
  end
end
