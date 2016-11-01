class RemoveCounterTime < ActiveRecord::Migration
  def change
    remove_column :actionmodules, :countertime
  end
end
