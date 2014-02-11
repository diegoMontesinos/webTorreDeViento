class AddSemblanceToColaborator < ActiveRecord::Migration
  def change
    add_column :colaborators, :semblance_en, :string
  end
end
