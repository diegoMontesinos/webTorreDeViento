class AddSprocket2ToColaboratorGridElements < ActiveRecord::Migration
  def change
    add_column :colaborator_grid_elements, :sprocket2, :string
  end
end
