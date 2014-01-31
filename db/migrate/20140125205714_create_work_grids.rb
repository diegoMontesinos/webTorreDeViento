class CreateWorkGrids < ActiveRecord::Migration
  def change
    create_table :work_grids do |t|

      t.timestamps
    end
  end
end
