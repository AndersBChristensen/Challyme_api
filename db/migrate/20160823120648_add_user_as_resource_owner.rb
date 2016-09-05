class AddUserAsResourceOwner < ActiveRecord::Migration
  def change
    add_foreign_key :table_name, :users, column: :resource_owner_id
  end
end
