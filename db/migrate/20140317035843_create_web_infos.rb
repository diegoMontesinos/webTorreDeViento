class CreateWebInfos < ActiveRecord::Migration
  def change
    create_table :web_infos do |t|
      t.string :type_info
      t.string :image

      t.timestamps
    end

    create_table :web_info_translations do |t|
      t.references :web_info
      t.string     :language_code
      t.text       :body
      t.timestamps
    end

    add_index :web_info_translations, [:web_info_id, :language_code], :unique => true, :name => 'web_info_translations_index'
  end
end
