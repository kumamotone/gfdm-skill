class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:create, :destroy] 
  before_action :correct_user, only: :destroy

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
  def newdrum
    @skill = Skill.new
  end

  def newguitar
    @skill = Skill.new
  end

  # GET /skills/1/edit
  def editdrum
  end

  def editguitar
  end

  def update_user_sp(skill)
    @hot = @user.skills.where(music_id: 1..711).order("sp DESC").limit(25)
    hot_sp = 0.0

    @hot.each do |h|
      hot_sp = hot_sp + h.sp
    end
    
    @other = @user.skills.where(music_id: 712..756).order("sp DESC").limit(25)
    other_sp = 0.0

    @other.each do |o|
      other_sp = other_sp + o.sp
    end
  end

  def create
    @skill = current_user.skills.build(skill_params) 
    
    if @skill.save
      if @skill.g_kind.nil?
        skill.sp = d_calc_sp(@skill) 
        @skill.update_attributes(skill_params)
        flash[:success] = "スキルが登録されました．"
        redirect_to drum_user_path 
      else
        skill.sp = d_calc_sp(@skill) 
        @skill.update_attributes(skill_params)
        flash[:success] = "スキルが登録されました．"
        redirect_to guitar_user_path
      end
    else
      render 'newdrum' 
    end
  end

  def update
    if @skill.update_attributes(skill_params)
      @skill.sp = d_calc_sp(@skill) 
      @skill.update_attributes(skill_params)
      flash[:success] = "スキルを更新しました．"
      redirect_to current_user
    else
      render 'editdrum'
    end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
   @skill.destroy
    redirect_to current_user, :flash => { :success => "スキルを削除しました．" }
  end

  def d_calc_sp(skill)
    rate = skill.rate
    level = ApplicationController.helpers.fetch_level(skill.music_id, skill.d_kind)
    return ((rate * level * 20) * 0.01).round(2) #.to_d.floor(2).to_f
  end

  def g_calc_sp(skill)
    rate = skill.rate
    level = ApplicationController.helpers.fetch_level(skill.music_id, skill.g_kind)
    return ((rate * level * 20) * 0.01).round(2) #.to_d.floor(2).to_f
  end


  private  

    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skill_params
      params[:skill].permit(:music_id, :user_id, :d_kind, :g_kind, :rate, :isfc, :comment) # define right permission
    end

    def correct_user
      @skill= current_user.skills.find_by(id: params[:id])
      redirect_to root_url if @skill.nil?
    end
end
