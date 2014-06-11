class AddNextToPressNotes < ActiveRecord::Migration
  def change
    add_column :press_notes, :next, :integer
  end
end
