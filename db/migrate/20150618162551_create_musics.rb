class CreateMusics < ActiveRecord::Migration
  def change
    create_table :musics do |t|
      t.string :name, null: false
      t.string :bpm
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
      t.boolean :ishot, null: false

      t.timestamps
    end
  end
end
