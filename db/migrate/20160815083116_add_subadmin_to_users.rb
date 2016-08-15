class AddSubadminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :subadmin, :boolean, default: false, null: false
  end
end
