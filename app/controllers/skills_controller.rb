class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:edit, :create, :destroy, :update] 
  before_action :correct_user, only: [:edit, :destroy, :update, :destroy]

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

  def updatedrum(id)
    @user = User.find(id)
    @sp = Sp.find_by_user_id(@user.id)

    #@hot= @user.skills.find_by_sql( ['SELECT s.* FROM "skills" AS s WHERE s."user_id" = ? AND (s."music_id" BETWEEN 713 AND 757) AND (s."kind" BETWEEN 0 AND 3) AND NOT EXISTS ( SELECT 1 FROM "skills" AS t WHERE s."music_id" = t."music_id" AND s."sp" < t."sp") ', @user.id]  )
    #@other = @user.skills.find_by_sql( ['SELECT s.* FROM "skills" AS s WHERE s."user_id" = ? AND (s."music_id" BETWEEN 1 AND 712) AND (s."kind" BETWEEN 0 AND 3) AND NOT EXISTS ( SELECT 1 FROM "skills" AS t WHERE s."music_id" = t."music_id" AND s."sp" < t."sp") ', @user.id]  )

    @hot = @user.skills.where(music_id: 713..757, kind: 0..3).order("sp DESC").group("music_id").order("sp DESC")
    @other = @user.skills.where(music_id: 1..712, kind: 0..3).order("sp DESC").group("music_id").order("sp DESC")# 終端位置変更の必要あり
    
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
   
    @sp.update( d: @skill_sp, dhot: @hot_sp, dother: @other_sp, dall: @all_sp)
    @sp.save
  end

  def updateguitar
     @user = User.find(params[:id])
    @sp = Sp.find_by_user_id(@user.id)

    #@hot= @user.skills.find_by_sql( ['SELECT s.* FROM "skills" AS s WHERE s."user_id" = ? AND (s."music_id" BETWEEN 713 AND 757) AND (s."kind" BETWEEN 4 AND 11) AND NOT EXISTS ( SELECT 1 FROM "skills" AS t WHERE s."music_id" = t."music_id" AND s."sp" < t."sp") ', @user.id]  )
    #@other = @user.skills.find_by_sql( ['SELECT s.* FROM "skills" AS s WHERE s."user_id" = ? AND (s."music_id" BETWEEN 1 AND 712) AND (s."kind" BETWEEN 4 AND 11) AND NOT EXISTS ( SELECT 1 FROM "skills" AS t WHERE s."music_id" = t."music_id" AND s."sp" < t."sp") ', @user.id]  )
 
    @hot = @user.skills.where(music_id: 713..757, kind: 4..11).order("sp DESC").group("music_id").order("sp DESC")
    @other = @user.skills.where(music_id: 1..712, kind: 4..11).order("sp DESC").group("music_id").order("sp DESC") # 終端位置変更の必要あり
    
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

    @sp.g = @skill_sp
    @sp.ghot = @hot_sp
    @sp.gother = @other_sp
    @sp.gall = @all_sp
    @sp.save
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = current_user.skills.build(skill_params) 
    if @skill.save
      @skill.sp = calc_sp(@skill) 
      @skill.update_attributes(skill_params)

      if @skill.kind.between?(0,3) 
        updatedrum(@skill.user_id)
      else
        updateguitar(@skill.user_id)
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

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
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

  def calc_sp(skill)
    rate = skill.rate
    level = ApplicationController.helpers.fetch_level(skill.music_id, skill.kind)
    return ((rate * level * 20) * 0.01).to_d.floor(2).to_f
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
