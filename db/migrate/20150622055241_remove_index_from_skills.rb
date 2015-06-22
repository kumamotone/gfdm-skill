class RemoveIndexFromSkills < ActiveRecord::Migration
  def change
    remove_index :skills, [:user_id, :music_id]
  end
end
