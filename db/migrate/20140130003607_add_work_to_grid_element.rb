class AddWorkToGridElement < ActiveRecord::Migration
  def change
    add_reference :grid_elements, :work, index: true
  end
end
