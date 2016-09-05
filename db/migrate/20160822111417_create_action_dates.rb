class CreateActionDates < ActiveRecord::Migration
  def change
    create_table :action_dates do |t|
      t.date :date
      t.timestamps null: false
      add_reference :actions, :action_dates, index: true, foreign_key: true
    end
  end
end
