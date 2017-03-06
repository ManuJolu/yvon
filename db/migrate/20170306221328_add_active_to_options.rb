class AddActiveToOptions < ActiveRecord::Migration[5.0]
  def change
    add_column :options, :active, :boolean, default: true
  end
end
