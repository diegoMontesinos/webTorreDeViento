class CreateColaborators < ActiveRecord::Migration
  def change
    create_table :colaborators do |t|
      t.string :name
      t.text :title
      t.text :cv_text
      t.text :semblance_text
      t.string :cv
      t.string :semblance
      t.boolean :frequent
      t.integer :next
      t.integer :previous

      t.timestamps
    end
  end
end
