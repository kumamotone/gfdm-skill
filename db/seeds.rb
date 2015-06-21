require "csv"

CSV.foreach('db/triboost_other.csv') do |row|
  Music.create(:name => row[0], :bpm => row[1], :d_bsc => row[2], :d_adv => row[3], :d_ext => row[4], :d_mas => row[5],
                 :g_bsc => row[6], :g_adv => row[7], :g_ext => row[8], :g_mas => row[9],
                 :b_bsc => row[10], :b_adv => row[11], :b_ext => row[12], :b_mas => row[13],
                 :ishot => row[14])
end

CSV.foreach('db/triboost_hot.csv') do |row|
  Music.create(:name => row[0], :bpm => row[1], :d_bsc => row[2], :d_adv => row[3], :d_ext => row[4], :d_mas => row[5],
                 :g_bsc => row[6], :g_adv => row[7], :g_ext => row[8], :g_mas => row[9],
                 :b_bsc => row[10], :b_adv => row[11], :b_ext => row[12], :b_mas => row[13],
                 :ishot => row[14])
end


