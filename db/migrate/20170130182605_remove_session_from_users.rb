class RemoveSessionFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :session
  end
end
