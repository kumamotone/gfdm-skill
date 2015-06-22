class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user, only: [:create, :destroy] 
  before_action :correct_user, only: :destroy

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
    if @skill.save
      @skill.sp = calc_sp(@skill) 
      @skill.update_attributes(skill_params)
      flash[:success] = "スキルが登録されました．"
      if (@skill.kind.between?(0,3))
        redirect_to drum_user_path(@skill.user_id)
      else
        redirect_to guitar_user_path(@skill.user_id)
      end
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
    return ((rate * level * 20) * 0.01).round(2) #.to_d.floor(2).to_f
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
      redirect_to root_url if @skill.nil?
    end
end
