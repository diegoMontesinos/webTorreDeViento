class FixTitleWorks < ActiveRecord::Migration
  def change
  	drop_table :work_translations

  	remove_column :works, :subtitle
  	remove_column :works, :description

  	add_column :works, :titles_text, :text

  	create_table :work_translations do |t|
      t.references :work
      t.string     :language_code
      t.text       :titles_text
      t.text       :credits
      t.text       :synopsis
      t.text       :program
      t.text       :notes

      t.timestamps
    end

    add_index :work_translations, [:work_id, :language_code], :unique => true
  end
end
