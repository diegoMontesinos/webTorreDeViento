class TranslateInFileFolder < ActiveRecord::Migration
  def change

  	create_table :file_folder_translations do |t|
      t.references :file_folder
      t.string     :language_code
      t.string     :name_folder
      t.timestamps
    end

    add_index :file_folder_translations, [:file_folder_id, :language_code], :unique => true, :name => 'file_folder_translations_index'

  end
end
