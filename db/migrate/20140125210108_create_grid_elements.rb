class CreateGridElements < ActiveRecord::Migration
  def change
    create_table :grid_elements do |t|
      t.references :work_grid, index: true
      t.references :work, index: true
      t.string :box
      t.decimal :x
      t.decimal :y

      t.timestamps
    end
  end
end
