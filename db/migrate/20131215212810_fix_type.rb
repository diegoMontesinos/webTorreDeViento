class FixType < ActiveRecord::Migration
  def change
  	rename_column :works, :type, :type_work
  end
end
