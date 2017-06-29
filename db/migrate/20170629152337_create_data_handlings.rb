class CreateDataHandlings < ActiveRecord::Migration
  def change
    create_table :data_handlings do |t|

      t.timestamps null: false
    end
  end
end
