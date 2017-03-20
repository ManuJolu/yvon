class AddUrlToRestaurant < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :ubereats_url, :string
    add_column :restaurants, :foodora_url, :string
  end
end
