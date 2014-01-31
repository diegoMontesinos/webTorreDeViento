class AddGridElementToWork < ActiveRecord::Migration
  def change
    add_reference :works, :grid_element, index: true
  end
end
