class AddInfoToUsers < ActiveRecord::Migration
  def change
    add_column :users, :profile, :string
    add_column :users, :d_comment, :string
    add_column :users, :g_comment, :string
    add_column :users, :place, :string
  end
end
