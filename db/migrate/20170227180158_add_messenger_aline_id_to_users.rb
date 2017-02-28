class AddMessengerAlineIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :messenger_aline_id, :string
  end
end
