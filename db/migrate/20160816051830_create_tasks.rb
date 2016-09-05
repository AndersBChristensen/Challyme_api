class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :title
      t.belongs_to :challenge, index: true
      
      t.timestamps null: false
    end
  end
end
