class AddPressNoteToPressElements < ActiveRecord::Migration
  def change
    add_reference :press_elements, :press_note, index: true
  end
end
