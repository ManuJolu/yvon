class AddFacebookPictureCheckToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :facebook_picture_check, :string
  end
end
