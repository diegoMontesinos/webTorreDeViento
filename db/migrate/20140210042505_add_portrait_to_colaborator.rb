class AddPortraitToColaborator < ActiveRecord::Migration
  def change
    add_column :colaborators, :portrait, :string
  end
end
