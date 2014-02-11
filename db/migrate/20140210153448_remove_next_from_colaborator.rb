class RemoveNextFromColaborator < ActiveRecord::Migration
  def change
    remove_column :colaborators, :next, :integer
  end
end
