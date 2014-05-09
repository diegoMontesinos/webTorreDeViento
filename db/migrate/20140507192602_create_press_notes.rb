class CreatePressNotes < ActiveRecord::Migration
  def change
    create_table :press_notes do |t|
      t.text :title

      t.timestamps
    end
  end
end
