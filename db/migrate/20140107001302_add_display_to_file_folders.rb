class AddDisplayToFileFolders < ActiveRecord::Migration
  def change
    add_column :file_folders, :display, :integer
  end
end
