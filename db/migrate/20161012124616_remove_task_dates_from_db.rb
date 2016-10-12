class RemoveTaskDatesFromDb < ActiveRecord::Migration
  def change
    drop_table :task_dates
  end
end
