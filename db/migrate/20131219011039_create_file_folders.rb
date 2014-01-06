class CreateFileFolders < ActiveRecord::Migration
  def change
    create_table :file_folders do |t|
      t.string     :name_folder
      t.references :holdable, polymorphic: true

      t.timestamps
    end
  end
end
