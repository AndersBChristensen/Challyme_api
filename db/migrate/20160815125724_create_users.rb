class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :birthday
      t.string :username
      t.string :phone
      t.string :email
      t.string :password
      t.string :gender
      t.boolean :active

      t.timestamps null: false
    end
  end
end
