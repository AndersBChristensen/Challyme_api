class RenameActionsIdInActionDate < ActiveRecord::Migration
  def change
    rename_column :action_dates, :actions_id, :action_id
  end
end
