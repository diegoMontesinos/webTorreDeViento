class AddHeadToCarouselElements < ActiveRecord::Migration
  def change
    add_column :carousel_elements, :head, :integer
  end
end
