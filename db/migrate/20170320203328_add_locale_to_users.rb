class AddLocaleToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :messenger_locale, :string
  end
end
