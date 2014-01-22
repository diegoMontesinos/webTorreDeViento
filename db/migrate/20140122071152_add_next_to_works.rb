class AddNextToWorks < ActiveRecord::Migration
  def change
    add_column :works, :next, :integer
  end
end
