class CreateColaboratorGridElements < ActiveRecord::Migration
  def change
    create_table :colaborator_grid_elements do |t|
      t.references :colaborator, index: true
      t.string :box
      t.string :sprocket

      t.timestamps
    end
  end
end
