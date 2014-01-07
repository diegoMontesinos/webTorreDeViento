class AddDisplayToWorks < ActiveRecord::Migration
  def change
    add_column :works, :display, :integer
  end
end
