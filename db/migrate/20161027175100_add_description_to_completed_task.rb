class AddDescriptionToCompletedTask < ActiveRecord::Migration
  def change
    add_column :completes, :description, :text, limit: 2200
  end
end
