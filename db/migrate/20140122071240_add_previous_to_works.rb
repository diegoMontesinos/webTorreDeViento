class AddPreviousToWorks < ActiveRecord::Migration
  def change
    add_column :works, :previous, :integer
  end
end
