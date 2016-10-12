class AddReferenceToTaskAndAction < ActiveRecord::Migration
  def change
    add_reference :action_dates, :tasks, index: true, foreign_key: true
  end
end
