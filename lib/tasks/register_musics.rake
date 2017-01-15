namespace :register_musics do
  desc "Tri-boost Re:EVOLVE の曲データを登録する"

  task :generate => :environment do
    # 処理を記述
    CSV.foreach('db/difficultyutf8.csv') do |row|
      ReMusic.create(:name => row[0].strip,
                     :g_bsc => row[1] || 0.0, :g_adv => row[2] || 0.0, :g_ext => row[3] || 0.0, :g_mas => row[4] || 0.0,
                   :b_bsc => row[5] || 0.0, :b_adv => row[6] || 0.0, :b_ext => row[7] || 0.0, :b_mas => row[8] || 0.0,
                   :d_bsc => row[9] || 0.0, :d_adv => row[10] || 0.0, :d_ext => row[11] || 0.0, :d_mas => row[12] || 0.0,
                   :ishot => false)
    end
  end
end
