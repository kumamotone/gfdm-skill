class AddTwitterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitterid, :string
  end
end
