class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|

      t.string :latitude
      t.string :longitude
      t.integer :altitude
      t.integer :course
      t.integer :completes_id
      t.timestamps null: false
    end
    add_index(:locations, :completes_id)
  end
end
