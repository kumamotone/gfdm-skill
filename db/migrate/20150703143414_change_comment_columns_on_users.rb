class ChangeCommentColumnsOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :d_comment, :text
    change_column :users, :g_comment, :text
  end
  def down
    # This might cause trouble if you have strings longer
    # than 255 characters.
    change_column :users, :d_comment, :string
    change_column :users, :g_comment, :string
  end
end
