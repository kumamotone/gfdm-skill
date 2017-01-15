class CreateReSkills < ActiveRecord::Migration
  def change
    create_table :re_skills do |t|
      t.integer :re_music_id
      t.integer :re_user_id
      t.integer :kind
      t.float :rate
      t.float :sp
      t.string :comment
      t.boolean :isfc

      t.timestamps
    end
    add_index :re_skills, :re_user_id
    add_index :re_skills, :re_music_id
    add_index :re_skills, [:re_user_id, :re_music_id]
    add_index :re_skills, [:re_user_id, :re_music_id, :kind], unique: true
  end
end
