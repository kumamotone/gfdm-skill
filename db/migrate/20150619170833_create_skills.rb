class CreateSkills < ActiveRecord::Migration
  def change
    create_table :skills do |t|
      t.integer :music_id
      t.integer :user_id
      t.float :d_bsc
      t.float :d_adv
      t.float :d_ext
      t.float :d_mas
      t.float :g_bsc
      t.float :g_adv
      t.float :g_ext
      t.float :g_mas
      t.float :b_bsc
      t.float :b_adv
      t.float :b_ext
      t.float :b_mas
      t.string :comment
      t.boolean :isfc

      t.timestamps
    end
    add_index :skills, :user_id
    add_index :skills, :music_id
    add_index :skills, [:user_id, :music_id]
  end
end
