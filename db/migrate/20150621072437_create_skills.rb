class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :music_id
      t.integer :user_id
      t.integer :kind
      t.float :rate
      t.float :sp
      t.string :comment
      t.boolean :isfc

      t.timestamps
    end
    add_index :skills, :user_id
    add_index :skills, :music_id
    add_index :skills, [:user_id, :music_id], unique: true
  end
end
