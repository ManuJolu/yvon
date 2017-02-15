class AddPositionToMenus < ActiveRecord::Migration[5.0]
  def change
    add_column :menus, :position, :integer
  end
end
