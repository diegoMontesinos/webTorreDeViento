class RemoveHeadToCarouselElements < ActiveRecord::Migration
  def change
    remove_column :carousel_elements, :head, :integer
  end
end
