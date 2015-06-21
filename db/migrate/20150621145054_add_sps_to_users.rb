class AddSpsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :d_sp, :float
    add_column :users, :d_hot_sp, :float
    add_column :users, :d_other_sp, :float
    add_column :users, :d_all_sp, :float
    add_column :users, :g_sp, :float
    add_column :users, :g_hot_sp, :float
    add_column :users, :g_other_sp, :float
    add_column :users, :g_all_sp, :float
   end
end
