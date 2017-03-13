class AddStripeToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :stripe_default_source_brand, :string
    add_column :users, :stripe_default_source_last4, :string
  end
end
