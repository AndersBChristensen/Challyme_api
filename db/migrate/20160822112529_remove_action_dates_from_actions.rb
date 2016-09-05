class RemoveActionDatesFromActions < ActiveRecord::Migration
  def change
    remove_column :actions, :action_dates_id
  end
end
