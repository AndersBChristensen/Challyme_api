class AddActionDatesToAction < ActiveRecord::Migration
  def change
    add_reference :action_dates, :actions, index: true, foreign_key: true
  end
end
