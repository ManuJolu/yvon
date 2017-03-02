class RenameMessengerPasswordFromRestaurants < ActiveRecord::Migration[5.0]
  def change
    rename_column :restaurants, :messenger_password, :messenger_pass
  end
end
