class SkillsController < ApplicationController
  before_action :set_skill, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :manage, :import]
  #before_action :signed_in_user, only: [:edit, :create, :destroy, :update] 
  #before_action :correct_user, only: [:edit, :destroy, :update, :destroy]

  def self.kind_choices
    [["BSC", 0],
     ["ADV", 1],
     ["EXT", 2],
     ["MAS", 3]]
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
    _skill = current_user.skills.build(skill_params)
    @skill = Skill.find_or_initialize_by(kind: _skill.kind, music_id: _skill.music_id, user_id: _skill.user_id)

    message = ""
    if @skill.id.nil?
      message = "スキルが登録されました。#{_skill.music.name} 達成率: #{_skill.rate} SP: #{calc_sp(_skill)}"
    else
      message = "スキルが更新されました。#{@skill.music.name} 達成率: #{@skill.rate} -> #{_skill.rate} SP: #{calc_sp(@skill)} -> #{calc_sp(_skill)} "
    end

    @skill.sp = calc_sp(_skill)
    @skill.rate = _skill.rate

    if @skill.save
      if @skill.kind.between?(0, 3)
        ApplicationController.helpers.updatedrum(@skill.user_id)
      else
        ApplicationController.helpers.updateguitar(@skill.user_id)
      end

      flash[:success] = message
      redirect_to new_skill_path
    else
      render 'new'
    end
  end

  def update_maxuser
    ApplicationController.helpers.create_max
  end

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
    @skill.sp = calc_sp(@skill)
    if @skill.update_attributes(skill_params)
      @skill.sp = calc_sp(@skill)
      @skill.update_attributes(skill_params)

      flash[:success] = "スキルを更新しました。 #{@skill.music.name} 達成率: #{@skill.rate} SP: #{calc_sp(@skill)}"
      if (@skill.kind.between?(0, 3))
        ApplicationController.helpers.updatedrum(@skill.user_id)
        redirect_to drum_user_path(@skill.user_id)
      else
        ApplicationController.helpers.updateguitar(@skill.user_id)
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
    if (@skill.kind.between?(0, 3))
      ApplicationController.helpers.updatedrum(@skill.user_id)
      redirect_to drum_user_path(@skill.user_id), :flash => {:success => "スキル (#{@skill.music.name}) を削除しました．"}
    else
      ApplicationController.helpers.updateguitar(@skill.user_id)
      redirect_to guitar_user_path(@skill.user_id), :flash => {:success => "スキル (#{@skill.music.name}) を削除しました．"}
    end
  end


  # これの実装が複数あるのはさすがにヤバすぎ
  def calc_sp(skill)
    rate = skill.rate.to_s.to_d
    level = ApplicationController.helpers.fetch_level_by_skill(skill).to_s.to_d
    return ((rate * level * 20) * BigDecimal("0.01")).to_s.to_d.floor(2).to_f
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
    redirect_to current_user, notice: "正しいユーザでログインしてください．" if @skill.nil?
  end
end
