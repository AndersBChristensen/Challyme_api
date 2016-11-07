class AddNewFeaturesToActionModules < ActiveRecord::Migration
  def change
    add_column :completes, :distance, :integer
    change_column :completes, :time, :integer
  end
end
