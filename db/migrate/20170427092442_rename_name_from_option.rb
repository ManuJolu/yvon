class RenameNameFromOption < ActiveRecord::Migration[5.0]
  def change
    rename_column :options, :name, :name_ut
  end
end
