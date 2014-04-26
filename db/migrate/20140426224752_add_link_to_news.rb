class AddLinkToNews < ActiveRecord::Migration
  def change
    add_column :news, :link, :text
  end
end
