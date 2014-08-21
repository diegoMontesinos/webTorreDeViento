class RemoveLinkFromNews < ActiveRecord::Migration
  def change
    remove_column :news, :link, :text
  end
end
