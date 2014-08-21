class CreateHomeNews < ActiveRecord::Migration
  def change
    create_table :home_news do |t|
      t.string :img_link
      t.references :new, index: true

      t.timestamps
    end
  end
end
