class ChangeScidTypeFromUsers < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :stripe_customer_id, :string
  end
end
