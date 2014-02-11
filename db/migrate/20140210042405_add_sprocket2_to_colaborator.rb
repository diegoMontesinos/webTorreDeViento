class AddSprocket2ToColaborator < ActiveRecord::Migration
  def change
    add_column :colaborators, :sproket_2, :string
  end
end
