class RemoveCvTextFromColaborator < ActiveRecord::Migration
  def change
    remove_column :colaborators, :cv_text, :text
  end
end
