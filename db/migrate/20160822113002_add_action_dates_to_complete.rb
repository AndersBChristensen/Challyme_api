class AddActionDatesToComplete < ActiveRecord::Migration
  def change
    add_reference :completes, :action_dates, index: true, foreign_key: true
  end
end
