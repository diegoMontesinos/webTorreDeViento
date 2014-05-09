class RemoveBackgroundFromPressElements < ActiveRecord::Migration
  def change
    remove_column :press_elements, :background, :string
  end
end
