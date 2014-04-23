class CreateNews < ActiveRecord::Migration
  def change
    create_table :news do |t|
      t.string :title
      t.string :image_new
      t.string :thumbnail

      t.timestamps
    end
  end
end
