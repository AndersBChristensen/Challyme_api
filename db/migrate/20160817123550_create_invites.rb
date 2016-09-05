class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
	  t.references :user
	  t.references :challenge
      t.timestamps null: false
    end
  end
end
