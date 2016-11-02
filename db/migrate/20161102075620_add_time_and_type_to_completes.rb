class AddTimeAndTypeToCompletes < ActiveRecord::Migration
  def change
    add_column :completes, :moduletype, :string
    add_column :completes, :time, :string
  end
end
