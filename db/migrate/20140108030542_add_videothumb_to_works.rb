class AddVideothumbToWorks < ActiveRecord::Migration
  def change
    add_column :works, :videothumb, :string
  end
end
