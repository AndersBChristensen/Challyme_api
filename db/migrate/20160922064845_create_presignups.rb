class CreatePresignups < ActiveRecord::Migration
  def change
    create_table :presignups do |t|

      t.string :email

      t.timestamps null: false
    end
  end
end
