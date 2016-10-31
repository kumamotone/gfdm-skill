module SkillsHelper
  def updatedrum(id)
    @user = User.find(id)

    @hot= @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id >= 712) AND
                                          (s.kind BETWEEN 0 AND 3)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 0 AND 3))
                                     ORDER BY sp DESC', @user.id])
    @other = @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id BETWEEN 1 AND 711) AND
                                          (s.kind BETWEEN 0 AND 3)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 0 AND 3))
                                     ORDER BY sp DESC', @user.id])


    #@hot = @user.skills.where(music_id: 712..900, kind: 0..3).order("sp DESC").group("music_id").order("sp DESC")
    #@other = @user.skills.where(music_id: 1..711, kind: 0..3).order("sp DESC").group("music_id").order("sp DESC")# 終端位置変更の必要あり

    # hot計算
    @hot_sp = 0.0
    @hot.first(25).each do |h|
      @hot_sp = @hot_sp + h.sp
    end

    # other計算
    @other_sp = 0.0
    @other.first(25).each do |o|
      @other_sp = @other_sp + o.sp
    end

    # hot_sp, other_sp round
    @hot_sp = @hot_sp.round(2)
    @other_sp = @other_sp.round(2)

    # sp計算
    @skill_sp = (@hot_sp + @other_sp).round(2)

    # all計算
    @all_sp = 0.0
    @hot.each do |h|
      @all_sp = @all_sp + h.sp
    end
    @other.each do |o|
      @all_sp = @all_sp + o.sp
    end

    # all sp round
    @all_sp = @all_sp.round(2)

    # DBに保存
    @user.update_attributes(d: @skill_sp, dhot: @hot_sp, dother: @other_sp, dall: @all_sp, skill_updated_at_d: Time.now)
  end

  def updateguitar (id)
    @user = User.find(id)

    @hot= @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id >= 712) AND
                                          (s.kind BETWEEN 4 AND 11)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 4 AND 11))
                                     ORDER BY sp DESC', @user.id])
    @other = @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id BETWEEN 1 AND 711) AND
                                          (s.kind BETWEEN 4 AND 11)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 4 AND 11))
                                     ORDER BY sp DESC', @user.id])

    #@hot = @user.skills.where(music_id: 712..900, kind: 4..11).order("sp DESC").group("music_id").order("sp DESC")
    #@other = @user.skills.where(music_id: 1..711, kind: 4..11).order("sp DESC").group("music_id").order("sp DESC") # 終端位置変更の必要あり

    # hot計算
    @hot_sp = 0.0
    @hot.first(25).each do |h|
      @hot_sp = @hot_sp + h.sp
    end

    # other計算
    @other_sp = 0.0
    @other.first(25).each do |o|
      @other_sp = @other_sp + o.sp
    end

    # hot_sp, other_sp round
    @hot_sp = @hot_sp.round(2)
    @other_sp = @other_sp.round(2)

    # sp計算
    @skill_sp = (@hot_sp + @other_sp).round(2)

    # all計算
    @all_sp = 0.0
    @hot.each do |h|
      @all_sp = @all_sp + h.sp
    end
    @other.each do |o|
      @all_sp = @all_sp + o.sp
    end

    #all sp round
    @all_sp = @all_sp.round(2)
    @user.update_attributes(g: @skill_sp, ghot: @hot_sp, gother: @other_sp, gall: @all_sp, skill_updated_at_g: Time.now)
  end

  def fetch_level_by_skill(skill)
    music = Music.find(skill.music_id)
    return fetch_level(music, skill.kind); _
  end

  def fetch_level(music, kind)
    case kind
      when 0 then
        music.d_bsc
      when 1 then
        music.d_adv
      when 2 then
        music.d_ext
      when 3 then
        music.d_mas
      when 4 then
        music.g_bsc
      when 5 then
        music.g_adv
      when 6 then
        music.g_ext
      when 7 then
        music.g_mas
      when 8 then
        music.b_bsc
      when 9 then
        music.b_adv
      when 10 then
        music.b_ext
      when 11 then
        music.b_mas
    end
  end

  def fetch_level_by_id(musicid, kind)
    music = Music.find(musicid)
    case kind
      when 0 then
        music.d_bsc
      when 1 then
        music.d_adv
      when 2 then
        music.d_ext
      when 3 then
        music.d_mas
      when 4 then
        music.g_bsc
      when 5 then
        music.g_adv
      when 6 then
        music.g_ext
      when 7 then
        music.g_mas
      when 8 then
        music.b_bsc
      when 9 then
        music.b_adv
      when 10 then
        music.b_ext
      when 11 then
        music.b_mas
    end
  end

  def create_max
    max_id = 3
    user = User.find(max_id)
    old_d_sp = (user.dhot + user.dother).round(2)
    old_g_sp = (user.ghot + user.gother).round(2)

    user.skills.destroy_all
    create_max_drum(true)
    create_max_drum(false)
    create_max_guitar(true)
    create_max_guitar(false)

    # drum の理論値ユーザの更新
    ApplicationController.helpers.updatedrum(max_id)

    # 理論値が更新されたら Twitter に post する
    user = User.find(max_id)  # 再取得する必要がある
    new_d_sp = (user.dhot + user.dother).round(2)

    if old_d_sp != new_d_sp then
      client = ApplicationController.helpers.get_twitter_client
      tweet_text = "ドラムの理論値が更新されました。 %.2f → %.2f http://tri.gfdm-skill.net/users/3/drum" % [old_d_sp, new_d_sp]
      if Rails.env == 'development'
        tweet_text = tweet_text + "(開発テスト)"
      end
      client.update(tweet_text)
    end

    # guitar の理論値ユーザの更新
    ApplicationController.helpers.updateguitar(max_id)

    # 理論値が更新されたら Twitter に post する
    user = User.find(max_id)  # 再取得する必要がある
    new_g_sp = (user.ghot + user.gother).round(2)

    if old_g_sp != new_g_sp then
      client = ApplicationController.helpers.get_twitter_client
      tweet_text = "ギターの理論値が更新されました。 %.2f → %.2f http://tri.gfdm-skill.net/users/3/guitar" % [old_g_sp, new_g_sp]
      if Rails.env == 'development'
        tweet_text = tweet_text + "(開発テスト)"
      end
      client.update(tweet_text)
    end
  end

  def create_max_guitar(ih)
    user = User.find(3)
    hm_gmas = Music.all.where(ishot: ih).where("name not like ?", "汎用 %").order("g_mas DESC").limit(40);
    hm_gext = Music.all.where(ishot: ih).where("name not like ?", "汎用 %").order("g_ext DESC").limit(40);
    hm_bmas = Music.all.where(ishot: ih).where("name not like ?", "汎用 %").order("b_mas DESC").limit(40);
    hm_bext = Music.all.where(ishot: ih).where("name not like ?", "汎用 %").order("b_ext DESC").limit(40);

    gmas_cnt = 0
    gext_cnt = 0
    bmas_cnt = 0
    bext_cnt = 0
    skill_cnt = 0
    last_level = 9.99
    while true do
      if hm_gmas[gmas_cnt].g_mas >= [hm_gext[gext_cnt].g_ext, hm_bmas[bmas_cnt].b_mas, hm_bext[bext_cnt].b_ext].max
        # すでにほかのが登録済みの場合はスキップ
        unless user.skills.where(music_id: hm_gmas[gmas_cnt].id).where("kind > ?", 3).empty?
          gmas_cnt += 1;
          next;
        end
        # スキル作成
        skill = Skill.new
        skill.user_id = 3
        skill.music_id = hm_gmas[gmas_cnt].id
        skill.rate = 100.0
        skill.kind = 7
        skill.sp = calc_sp(skill)
        if skill.valid?
          # 申し訳程度のvalidをしてセーブ
          skill.save
        end
        gmas_cnt += 1;
        skill_cnt += 1;
        last_level = hm_gmas[gmas_cnt].g_mas
      elsif hm_gext[gext_cnt].g_ext >= [hm_gmas[gmas_cnt].g_mas, hm_bmas[bmas_cnt].b_mas, hm_bext[bext_cnt].b_ext].max
        # すでにほかのが登録済みの場合はスキップ
        unless user.skills.where(music_id: hm_gext[gext_cnt].id).where("kind > ?", 3).empty?
          gext_cnt += 1;
          next;
        end
        # スキル作成
        skill = Skill.new
        skill.user_id = 3
        skill.music_id = hm_gext[gext_cnt].id
        skill.rate = 100.0
        skill.kind = 6
        skill.sp = calc_sp(skill)
        # 申し訳程度のvalidをしてセーブ
        if skill.valid?
          skill.save
        end
        gext_cnt += 1;
        skill_cnt += 1;
        last_level = hm_gext[gext_cnt].g_ext
      elsif hm_bmas[bmas_cnt].b_mas >= [hm_gext[gext_cnt].g_ext, hm_gmas[gmas_cnt].g_mas, hm_bext[bext_cnt].b_ext].max
        # すでにほかのが登録済みの場合はスキップ
        unless user.skills.where(music_id: hm_bmas[bmas_cnt].id).where("kind > ?", 3).empty?
          bmas_cnt += 1;
          next;
        end
        # スキル作成
        skill = Skill.new
        skill.user_id = 3
        skill.music_id = hm_bmas[bmas_cnt].id
        skill.rate = 100.0
        skill.kind = 11
        skill.sp = calc_sp(skill)
        if skill.valid?
          # 申し訳程度のvalidをしてセーブ
          skill.save
        end
        bmas_cnt += 1;
        skill_cnt += 1;
        last_level = hm_bmas[bmas_cnt].b_mas
      elsif hm_bext[bext_cnt].b_ext >= [hm_gmas[gmas_cnt].g_mas, hm_bmas[bmas_cnt].b_mas, hm_gext[gext_cnt].g_ext].max
        # すでにほかのが登録済みの場合はスキップ
        unless user.skills.where(music_id: hm_bext[bext_cnt].id).where("kind > ?", 3).empty?
          bext_cnt += 1;
          next;
        end
        # スキル作成
        skill = Skill.new
        skill.user_id = 3
        skill.music_id = hm_bext[bext_cnt].id
        skill.rate = 100.0
        skill.kind = 10
        skill.sp = calc_sp(skill)
        # 申し訳程度のvalidをしてセーブ
        if skill.valid?
          skill.save
        end
        bext_cnt += 1;
        skill_cnt += 1;
        last_level = hm_bext[bext_cnt].b_ext
      end

      break if skill_cnt >= 25
    end
    # スキル下限の曲も表示したいので，登録する

    while hm_gmas[gmas_cnt].g_mas == last_level
      # すでにほかのが登録済みの場合はスキップ
      unless user.skills.where(music_id: hm_gmas[gmas_cnt].id).where("kind > ?", 3).empty?
        gmas_cnt += 1;
        next;
      end
      # スキル作成
      skill = Skill.new
      skill.user_id = 3
      skill.music_id = hm_gmas[gmas_cnt].id
      skill.rate = 100.0
      skill.kind = 7
      skill.sp = calc_sp(skill)
      if skill.valid?
        # 申し訳程度のvalidをしてセーブ
        skill.save
      end
      gmas_cnt += 1;
    end

    while hm_gext[gext_cnt].g_ext == last_level
      # すでにほかのが登録済みの場合はスキップ
      unless user.skills.where(music_id: hm_gext[gext_cnt].id).where("kind > ?", 3).empty?
        gext_cnt += 1;
        next;
      end
      # スキル作成
      skill = Skill.new
      skill.user_id = 3
      skill.music_id = hm_gext[gext_cnt].id
      skill.rate = 100.0
      skill.kind = 6
      skill.sp = calc_sp(skill)
      # 申し訳程度のvalidをしてセーブ
      if skill.valid?
        skill.save
      end
      gext_cnt += 1;
    end

    while hm_bmas[bmas_cnt].b_mas == last_level
      # すでにほかのが登録済みの場合はスキップ
      unless user.skills.where(music_id: hm_bmas[bmas_cnt].id).where("kind > ?", 3).empty?
        bmas_cnt += 1;
        next;
      end
      # スキル作成
      skill = Skill.new
      skill.user_id = 3
      skill.music_id = hm_bmas[bmas_cnt].id
      skill.rate = 100.0
      skill.kind = 11
      skill.sp = calc_sp(skill)
      if skill.valid?
        # 申し訳程度のvalidをしてセーブ
        skill.save
      end
      bmas_cnt += 1;
    end

    while hm_bext[bext_cnt].b_ext == last_level
      # すでにほかのが登録済みの場合はスキップ
      unless user.skills.where(music_id: hm_bext[bext_cnt].id).where("kind > ?", 3).empty?
        bext_cnt += 1;
        next;
      end
      # スキル作成
      skill = Skill.new
      skill.user_id = 3
      skill.music_id = hm_bext[bext_cnt].id
      skill.rate = 100.0
      skill.kind = 10
      skill.sp = calc_sp(skill)
      # 申し訳程度のvalidをしてセーブ
      if skill.valid?
        skill.save
      end
      bext_cnt += 1;
    end
  end

  def create_max_drum(ih)
    user = User.find(3)
    hm_mas = Music.all.where(ishot: ih).where("name not like ?", "汎用 %").order("d_mas DESC").limit(40);
    hm_ext = Music.all.where(ishot: ih).where("name not like ?", "汎用 %").order("d_ext DESC").limit(40);

    mas_cnt = 0
    ext_cnt = 0
    skill_cnt = 0
    last_level = 9.99
    while true do
      if hm_mas[mas_cnt].d_mas >= hm_ext[ext_cnt].d_ext
        # すでにEXTが登録済みの場合はスキップ
        unless user.skills.where(music_id: hm_mas[mas_cnt].id).where("kind < ?", 4).empty?
          mas_cnt += 1;
          next;
        end
        # スキル作成
        skill = Skill.new
        skill.user_id = 3
        skill.music_id = hm_mas[mas_cnt].id
        skill.rate = 100.0
        skill.kind = 3
        skill.sp = calc_sp(skill)
        if skill.valid?
          # 申し訳程度のvalidをしてセーブ
          skill.save
        end
        mas_cnt += 1;
        skill_cnt += 1;
        last_level = hm_mas[mas_cnt].d_mas
      else
        # すでにMASが登録済みの場合はスキップ
        unless user.skills.where(music_id: hm_ext[ext_cnt].id).where("kind < ?", 4).empty?
          ext_cnt += 1;
          next;
        end
        # スキル作成
        skill = Skill.new
        skill.user_id = 3
        skill.music_id = hm_ext[ext_cnt].id
        skill.rate = 100.0
        skill.kind = 2
        skill.sp = calc_sp(skill)
        # 申し訳程度のvalidをしてセーブ
        if skill.valid?
          skill.save
        end
        ext_cnt += 1;
        skill_cnt += 1;
        last_level = hm_ext[ext_cnt].d_ext
      end

      break if skill_cnt >= 25
    end

    # スキル下限の曲も表示したいので，登録する

    while hm_mas[mas_cnt].d_mas == last_level
      # スキル作成
      skill = Skill.new
      skill.user_id = 3
      skill.music_id = hm_mas[mas_cnt].id
      skill.rate = 100.0
      skill.kind = 3
      skill.sp = calc_sp(skill)
      if skill.valid?
        # 申し訳程度のvalidをしてセーブ
        skill.save
      end
      mas_cnt += 1;
    end

    while hm_ext[ext_cnt].d_ext == last_level
      # すでにMASが登録済みの場合はスキップ
      unless user.skills.where(music_id: hm_ext[ext_cnt].id).empty?
        ext_cnt = ext_cnt + 1;
        next;
      end
      # スキル作成
      skill = Skill.new
      skill.user_id = 3
      skill.music_id = hm_ext[ext_cnt].id
      skill.rate = 100.0
      skill.kind = 2
      skill.sp = calc_sp(skill)
      if skill.valid?
        # 申し訳程度のvalidをしてセーブ
        skill.save
      end
      ext_cnt = ext_cnt + 1;
    end
  end
end
