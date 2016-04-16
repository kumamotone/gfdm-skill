class AddSkillupdatedatToUsers < ActiveRecord::Migration
  def up
    add_column :users, :skill_updated_at_d, :datetime
    add_column :users, :skill_updated_at_g, :datetime
  end
  def down
    remove_column :users, :skill_updated_at_d
    remove_column :users, :skill_updated_at_g
  end
end
