class AddIndexToSkills < ActiveRecord::Migration
  def change
    add_index :skills, [:user_id, :music_id, :kind], unique: true
  end
end
