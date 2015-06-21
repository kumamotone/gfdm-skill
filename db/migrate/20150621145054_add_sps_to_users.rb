class AddSpsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :sp, :float
    add_column :users, :hot_sp, :float
    add_column :users, :other_sp, :float
    add_column :users, :all_sp, :float
  end
end
