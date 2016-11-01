class Renametype < ActiveRecord::Migration
  def change
    rename_column :actionmodules, :type, :moduletype
  end
end
