class CreateChallenges < ActiveRecord::Migration
  def change
    create_table :challenges do |t|
      t.string :title
      t.string :prize
      t.belongs_to :user, index: true

      t.timestamps null: false
    end
  end
end
