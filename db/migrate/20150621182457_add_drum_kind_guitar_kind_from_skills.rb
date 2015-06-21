class AddDrumKindGuitarKindFromSkills < ActiveRecord::Migration
  def change
    add_column :skills, :d_kind, :integer
    add_column :skills, :g_kind, :integer
    add_index :skills, :user_id
    add_index :skills, [:user_id, :music_id]
    add_index :skills, [:user_id, :music_id, :g_kind], unique: true
    add_index :skills, [:user_id, :music_id, :d_kind], unique: true
   end
end
