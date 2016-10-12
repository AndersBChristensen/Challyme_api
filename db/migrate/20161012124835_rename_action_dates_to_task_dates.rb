class RenameActionDatesToTaskDates < ActiveRecord::Migration
  def change
    rename_table :action_dates, :task_dates
  end
end
