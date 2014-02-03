class AddDisplayToGridElement < ActiveRecord::Migration
  def change
    add_column :grid_elements, :display, :integer
  end
end
