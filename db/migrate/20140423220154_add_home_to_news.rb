class AddHomeToNews < ActiveRecord::Migration
  def change
    add_column :news, :home, :integer
  end
end
