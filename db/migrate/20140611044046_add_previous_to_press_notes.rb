class AddPreviousToPressNotes < ActiveRecord::Migration
  def change
    add_column :press_notes, :previous, :integer
  end
end
