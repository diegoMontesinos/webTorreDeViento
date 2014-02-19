class AddTitlesGridToWorkTranslations < ActiveRecord::Migration
  def change
    add_column :work_translations, :titles_grid, :text
  end
end
