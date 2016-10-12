class ChangeFuckedReferences < ActiveRecord::Migration
  def change
    remove_column :action_dates, :tasks_id
    remove_column :actionmodules, :actions_id
  end
end
