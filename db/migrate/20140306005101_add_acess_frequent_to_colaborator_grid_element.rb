class AddAcessFrequentToColaboratorGridElement < ActiveRecord::Migration
  def change
    add_column :colaborator_grid_elements, :accessFrequent, :boolean
  end
end
