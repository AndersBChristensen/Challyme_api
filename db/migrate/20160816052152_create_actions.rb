class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.timestamps null: false
      
      t.belongs_to :task, index: true
    end
  end
end
