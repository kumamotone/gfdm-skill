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
 end
end
