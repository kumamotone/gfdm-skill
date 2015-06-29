module SkillsHelper
  def updatedrum(id)
    @user = User.find(id)

    @hot= @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 712 AND 900) AND (s.kind BETWEEN 0 AND 3) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 0 AND 3)) ', @user.id]  )
    @other = @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 1 AND 711) AND (s.kind BETWEEN 0 AND 3) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 0 AND 3)) ', @user.id]  )

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
    @user.update_attributes(d: @skill_sp, dhot: @hot_sp, dother: @other_sp, dall: @all_sp)
  end

  def updateguitar (id)
    @user = User.find(id)

    @hot= @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 712 AND 900) AND (s.kind BETWEEN 4 AND 11) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 4 AND 11)) ', @user.id]  )
    @other = @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 1 AND 711) AND (s.kind BETWEEN 4 AND 11) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 4 AND 11)) ', @user.id]  )
 
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
    @user.update_attributes(g: @skill_sp, ghot: @hot_sp, gother: @other_sp, gall: @all_sp) 
  end
 
  def fetch_level_by_skill(skill)
    music = Music.find(skill.music_id)
    return fetch_level(music, skill.kind);_
  end

  def fetch_level(music ,kind)
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


end
