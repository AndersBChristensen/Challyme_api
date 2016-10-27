class RenameType < ActiveRecord::Migration
  def change
    rename_column :activities, :type, :feed_type
  end
end
