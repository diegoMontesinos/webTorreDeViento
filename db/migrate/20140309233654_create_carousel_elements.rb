class CreateCarouselElements < ActiveRecord::Migration
  def change
    create_table :carousel_elements do |t|
      t.integer :photo
      t.references :home_carousel, index: true
      t.decimal :x
      t.decimal :y
      t.decimal :w
      t.decimal :h
      t.integer :previous
      t.integer :next

      t.timestamps
    end
  end
end
