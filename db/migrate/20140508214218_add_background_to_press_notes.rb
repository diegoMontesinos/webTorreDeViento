class AddBackgroundToPressNotes < ActiveRecord::Migration
  def change
    add_column :press_notes, :background, :string
  end
end
