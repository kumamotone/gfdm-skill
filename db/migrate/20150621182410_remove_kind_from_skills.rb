class RemoveKindFromSkills < ActiveRecord::Migration
  def change
    remove_column :skills, :kind, :integer
  end
end
