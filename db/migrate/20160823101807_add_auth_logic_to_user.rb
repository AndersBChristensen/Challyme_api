class AddAuthLogicToUser < ActiveRecord::Migration
  def change
    add_column :users, :crypted_password, :string
    add_column :users, :password_salt, :string
    add_column :users, :persistence_token, :string
    add_column :users, :auth_token, :string
    add_column :users, :cleartext_password, :string
    add_column :users, :is_super_admin, :boolean, default: false
    add_column :users, :is_admin, :boolean, default: false
  end
end
