class RemoveHomeFromNews < ActiveRecord::Migration
  def change
    remove_column :news, :home, :integer
  end
end
