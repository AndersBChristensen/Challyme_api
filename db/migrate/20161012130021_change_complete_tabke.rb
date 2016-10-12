class ChangeCompleteTabke < ActiveRecord::Migration
  def change
    remove_column :completes, :action_dates_id
    add_reference :completes, :task_date, index: true, foreign_key: true
  end
end
