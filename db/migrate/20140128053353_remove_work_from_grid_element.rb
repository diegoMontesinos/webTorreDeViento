class RemoveWorkFromGridElement < ActiveRecord::Migration
  def change
    remove_reference :grid_elements, :work, index: true
  end
end
