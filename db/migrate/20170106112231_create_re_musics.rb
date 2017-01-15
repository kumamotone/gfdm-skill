class CreateReMusics < ActiveRecord::Migration
  def change
    create_table :re_musics do |t|
      t.string :name, null: false
      t.string :artist
      t.float :d_bsc, default: 0.0
      t.float :d_adv, default: 0.0
      t.float :d_ext, default: 0.0
      t.float :d_mas, default: 0.0
      t.float :g_bsc, default: 0.0
      t.float :g_adv, default: 0.0
      t.float :g_ext, default: 0.0
      t.float :g_mas, default: 0.0
      t.float :b_bsc, default: 0.0
      t.float :b_adv, default: 0.0
      t.float :b_ext, default: 0.0
      t.float :b_mas, default: 0.0
      t.boolean :ishot, null: false

      t.timestamps
    end
  end
end
