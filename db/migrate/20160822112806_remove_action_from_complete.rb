class RemoveActionFromComplete < ActiveRecord::Migration
  def change
    remove_column :completes, :action_id
  end
end
