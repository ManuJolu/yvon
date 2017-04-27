class RenameAboutFromRestaurant < ActiveRecord::Migration[5.0]
  def change
    rename_column :restaurants, :about, :about_ut
  end
end
