class EnglishToPressNotes < ActiveRecord::Migration
	def change

	  	create_table :press_note_translations do |t|
	      t.references :press_note
	      t.string     :language_code
	      t.text       :title
	      t.timestamps
	    end

	    add_index :press_note_translations, [:press_note_id, :language_code], :unique => true, :name => "press_note_translations_index"
	end
end
