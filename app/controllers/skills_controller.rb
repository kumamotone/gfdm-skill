class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :manage, :import]
  #before_action :signed_in_user, only: [:edit, :create, :destroy, :update] 
  #before_action :correct_user, only: [:edit, :destroy, :update, :destroy]

  def self.kind_choices
    [["BSC",0],
     ["ADV",1],
     ["EXT",2],
     ["MAS",3]]
  end

  # GET /skills
  # GET /skills.json
  def index
    @skills = Skill.all
  end

  # GET /skills/1
  # GET /skills/1.json
  def show
  end

  # GET /skills/new
  def new
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def edit
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = current_user.skills.build(skill_params) 
    @skill.sp = calc_sp(@skill) 
    if @skill.save
      if @skill.kind.between?(0,3) 
        ApplicationController.helpers.updatedrum(@skill.user_id)
      else
        ApplicationController.helpers.updateguitar(@skill.user_id)
      end

      flash[:success] = "スキルが登録されました．"
      redirect_to new_skill_path
      #if (@skill.kind.between?(0,3))
      #  redirect_to drum_user_path(@skill.user_id)
      #else
      #  redirect_to guitar_user_path(@skill.user_id)
      #end
    else
      render 'new' 
    end
  end

  def update_maxuser 
    create_max    
  end

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
    @skill.sp = calc_sp(@skill) 
    if @skill.update_attributes(skill_params)
    @skill.sp = calc_sp(@skill) 
      @skill.update_attributes(skill_params)
      flash[:success] = "スキルを更新しました．"
       if (@skill.kind.between?(0,3))
        redirect_to drum_user_path(@skill.user_id)
      else
        redirect_to guitar_user_path(@skill.user_id)
      end
    else
      render 'edit'
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
   @skill.destroy
      if (@skill.kind.between?(0,3))
        redirect_to drum_user_path(@skill.user_id), :flash => { :success => "スキルを削除しました．" }
      else
        redirect_to guitar_user_path(@skill.user_id), :flash => { :success => "スキルを削除しました．" }
      end
  end
   
  def create_max
   max_id = 3
   user = User.find(max_id)
   user.skills.destroy_all;
   create_max_drum(true) 
   create_max_drum(false) 
   create_max_guitar(true) 
   create_max_guitar(false) 
  end

  def create_max_guitar(ih)
    user = User.find(3)
    hm_gmas = Music.all.where(ishot: ih).order("g_mas DESC").limit(40);
    hm_gext = Music.all.where(ishot: ih).order("g_ext DESC").limit(40);
    hm_bmas = Music.all.where(ishot: ih).order("b_mas DESC").limit(40);
    hm_bext = Music.all.where(ishot: ih).order("b_ext DESC").limit(40);

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
    hm_mas = Music.all.where(ishot: ih).order("d_mas DESC").limit(40);
    hm_ext = Music.all.where(ishot: ih).order("d_ext DESC").limit(40);

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

  # これの実装が複数あるのはさすがにヤバすぎ
  def calc_sp(skill)
    rate = skill.rate
    level = ApplicationController.helpers.fetch_level_by_skill(skill)
    return ((rate * level * 20) * 0.01).to_s.to_d.floor(2).to_f
  end

  private  

    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skill_params
      params[:skill].permit(:music_id, :user_id, :kind, :rate, :isfc, :comment) # define right permission
    end

    def correct_user
      @skill= current_user.skills.find_by(id: params[:id])
      redirect_to current_user , notice: "正しいユーザでログインしてください．" if @skill.nil?
    end
end
