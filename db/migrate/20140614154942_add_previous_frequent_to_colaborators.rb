class AddPreviousFrequentToColaborators < ActiveRecord::Migration
  def change
    add_column :colaborators, :previous_frequent, :integer
  end
end
