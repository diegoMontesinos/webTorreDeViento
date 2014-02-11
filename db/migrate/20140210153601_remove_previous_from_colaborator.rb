class RemovePreviousFromColaborator < ActiveRecord::Migration
  def change
    remove_column :colaborators, :previous, :integer
  end
end
