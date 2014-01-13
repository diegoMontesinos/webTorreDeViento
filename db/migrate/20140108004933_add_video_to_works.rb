class AddVideoToWorks < ActiveRecord::Migration
  def change
    add_column :works, :video, :string
  end
end
