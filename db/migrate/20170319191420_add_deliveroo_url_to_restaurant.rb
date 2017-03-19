class AddDeliverooUrlToRestaurant < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :deliveroo_url, :string
  end
end
