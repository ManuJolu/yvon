class AddMessengerUserRefToRestaurants < ActiveRecord::Migration[5.0]
  def change
    add_reference :restaurants, :messenger_user, foreign_key: { to_table: :users }
  end
end
