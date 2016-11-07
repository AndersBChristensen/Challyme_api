class AddDistanceToActionModules < ActiveRecord::Migration
  def change
    add_column :actionmodules, :distance, :integer
  end
end
