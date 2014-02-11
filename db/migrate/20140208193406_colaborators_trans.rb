class ColaboratorsTrans < ActiveRecord::Migration
  def change

  	create_table :colaborator_translations do |t|
      t.references :colaborator
      t.string     :language_code
      t.text       :cv_text
      t.text       :semblance_text
      t.timestamps
    end

    add_index :colaborator_translations, [:colaborator_id, :language_code], :unique => true, :name => 'colaborator_trans_index'

  end
end
