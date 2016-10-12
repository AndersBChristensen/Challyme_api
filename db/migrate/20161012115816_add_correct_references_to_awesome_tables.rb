class AddCorrectReferencesToAwesomeTables < ActiveRecord::Migration
  def change
    add_reference :action_dates, :task, index: true, foreign_key: true
    add_reference :actionmodules, :action, index: true, foreign_key: true
  end
end
