class RemoveGridElementFromWork < ActiveRecord::Migration
  def change
    remove_reference :works, :grid_element, index: true
  end
end
