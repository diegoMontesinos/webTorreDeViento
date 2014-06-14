class EnglishToPressElements < ActiveRecord::Migration
	def change

	  	create_table :press_element_translations do |t|
	      t.references :press_element
	      t.string     :language_code
	      t.text       :body
	      t.timestamps
	    end

	    add_index :press_element_translations, [:press_element_id, :language_code], :unique => true, :name => "press_element_translations_index"
	end
end
