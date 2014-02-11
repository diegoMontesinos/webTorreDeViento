class RemoveCvTextFromColaboratorTranslation < ActiveRecord::Migration
  def change
    remove_column :colaborator_translations, :cv_text, :text
  end
end
