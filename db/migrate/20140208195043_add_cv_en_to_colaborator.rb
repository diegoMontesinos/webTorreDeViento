class AddCvEnToColaborator < ActiveRecord::Migration
  def change
    add_column :colaborators, :cv_en, :string
  end
end
