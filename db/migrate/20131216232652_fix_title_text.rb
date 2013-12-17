class FixTitleText < ActiveRecord::Migration
  def change
  	drop_table :work_translations

  	remove_column :works, :titles_text
  	remove_column :works, :credits
  	remove_column :works, :synopsis
  	remove_column :works, :program
  	remove_column :works, :notes

  	add_column :works, :titles_text, :string
  	add_column :works, :credits, :string
  	add_column :works, :synopsis, :string
  	add_column :works, :program, :string
  	add_column :works, :notes, :string

  	create_table :work_translations do |t|
      t.references :work
      t.string     :language_code
      t.string     :titles_text
      t.string     :credits
      t.string     :synopsis
      t.string     :program
      t.string     :notes

      t.timestamps
    end

    add_index :work_translations, [:work_id, :language_code], :unique => true

  end
end
