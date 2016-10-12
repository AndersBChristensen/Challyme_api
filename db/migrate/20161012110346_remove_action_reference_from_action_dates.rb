class RemoveActionReferenceFromActionDates < ActiveRecord::Migration
  def change
    remove_column :action_dates, :action_id
  end
end
