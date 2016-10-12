class CreateActionmodules < ActiveRecord::Migration
  def change
    create_table :actionmodules do |t|

      t.integer :countertype #if 0 then up, if 1 then down
      t.integer :countertime
      t.string :text
      t.timestamps null: false
    end
  end
end
