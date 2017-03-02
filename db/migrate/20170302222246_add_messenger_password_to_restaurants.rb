class AddMessengerPasswordToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_column :restaurants, :messenger_password, :string
  end
end
