class CreateDownloads < ActiveRecord::Migration
  def change
    create_table :downloads do |t|
      t.string :title
      t.string :attachment
      t.string :thumbnail

      t.timestamps
    end
  end
end
