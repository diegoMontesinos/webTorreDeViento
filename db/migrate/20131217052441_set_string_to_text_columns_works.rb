class SetStringToTextColumnsWorks < ActiveRecord::Migration
  def change
  	drop_table :work_translations

  	remove_column :works, :titles_text
  	remove_column :works, :credits
  	remove_column :works, :synopsis
  	remove_column :works, :program
  	remove_column :works, :notes

  	add_column :works, :titles_text, :text
  	add_column :works, :credits, :text
  	add_column :works, :synopsis, :text
  	add_column :works, :program, :text
  	add_column :works, :notes, :text

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
