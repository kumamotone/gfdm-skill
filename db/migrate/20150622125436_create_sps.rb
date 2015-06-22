class CreateSps < ActiveRecord::Migration
  def change
    create_table :sps do |t|
      t.integer :user_id
      t.float :d
      t.float :dhot
      t.float :dother
      t.float :dall
      t.float :g
      t.float :ghot
      t.float :gother
      t.float :gall

      t.timestamps
    end
    add_index :sps, :user_id
  end
end
