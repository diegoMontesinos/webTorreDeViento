class AddHToGridElement < ActiveRecord::Migration
  def change
    add_column :grid_elements, :h, :decimal
  end
end
