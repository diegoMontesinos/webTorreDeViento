class CreateWorks < ActiveRecord::Migration
  def change
    create_table :works do |t|
      t.string :type
      t.string :title
      t.string :subtitle
      t.string :description
      t.text :credits
      t.text :synopsis
      t.text :program
      t.text :notes

      t.timestamps
    end

    create_table :work_translations do |t|
      t.references :work
      t.string     :language_code
      t.string     :title
      t.string     :subtitle
      t.string     :description
      t.text       :credits
      t.text       :synopsis
      t.text       :program
      t.text       :notes

      t.timestamps
    end

    add_index :work_translations, [:work_id, :language_code], :unique => true
  end
end
