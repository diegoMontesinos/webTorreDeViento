class AddSprocket1ToColaborator < ActiveRecord::Migration
  def change
    add_column :colaborators, :sproket_1, :string
  end
end
