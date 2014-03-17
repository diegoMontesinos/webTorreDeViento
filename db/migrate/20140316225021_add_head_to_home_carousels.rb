class AddHeadToHomeCarousels < ActiveRecord::Migration
  def change
    add_column :home_carousels, :head, :integer
  end
end
