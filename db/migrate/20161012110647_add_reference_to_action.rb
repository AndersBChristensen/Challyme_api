class AddReferenceToAction < ActiveRecord::Migration
  def change
    add_reference :actionmodules, :actions, index: true, foreign_key: true
  end
end
