class AddSpToSkills < ActiveRecord::Migration
  def change
    add_column :skills, :sp, :float
  end
end
