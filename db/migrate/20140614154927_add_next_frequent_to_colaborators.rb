class AddNextFrequentToColaborators < ActiveRecord::Migration
  def change
    add_column :colaborators, :next_frequent, :integer
  end
end
