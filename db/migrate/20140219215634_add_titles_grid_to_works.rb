class AddTitlesGridToWorks < ActiveRecord::Migration
  def change
    add_column :works, :titles_grid, :text
  end
end
