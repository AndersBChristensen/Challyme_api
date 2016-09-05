class CreateTaskDates < ActiveRecord::Migration
  def change
    create_table :task_dates do |t|
      t.date :date
      t.timestamps null: false
      
      t.belongs_to :task, index: true
    end
  end
end
