class CreateCompletes < ActiveRecord::Migration
  def change
    create_table :completes do |t|
      t.string :video
      t.string :image
      t.references :action
      t.references :invite
      t.timestamps null: false
    end
  end
end
