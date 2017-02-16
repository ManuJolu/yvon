class AddPositionToOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :options, :position, :integer
  end
end
