class CreatePressElements < ActiveRecord::Migration
  def change
    create_table :press_elements do |t|
      t.text :body
      t.string :background

      t.timestamps
    end
  end
end
