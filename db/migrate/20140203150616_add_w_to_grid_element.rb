class AddWToGridElement < ActiveRecord::Migration
  def change
    add_column :grid_elements, :w, :decimal
  end
end
