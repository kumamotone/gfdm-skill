json.array!(@musics) do |music|
  json.extract! music, :id, :name, :bpm, :d_bsc, :d_adv, :d_ext, :d_mas, :g_bsc, :g_adv, :g_ext, :g_mas, :b_bsc, :b_adv, :b_ext, :b_mas, :ishot
  json.url music_url(music, format: :json)
end