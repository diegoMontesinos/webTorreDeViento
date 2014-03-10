class CreateHomeCarousels < ActiveRecord::Migration
  def change
    create_table :home_carousels do |t|

      t.timestamps
    end
  end
end
