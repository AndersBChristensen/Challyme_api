class CreateUserPoints < ActiveRecord::Migration
  def change
    create_table :user_points do |t|
      t.integer :point_type
      t.timestamps null: false
    end

    add_reference :user_points, :user, index: true, foreign_key: true
  end
end
