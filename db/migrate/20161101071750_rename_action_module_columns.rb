class RenameActionModuleColumns < ActiveRecord::Migration
  def change
    rename_column :actionmodules, :text, :type
    rename_column :actionmodules, :countertype, :time
  end
end
