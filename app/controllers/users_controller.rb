class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :manage, :import]
  # before_action :correct_user,   only: [:edit, :update, :manage, :import]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.all
    #@users = User.paginate(page: params[:page])
  end

   def import
    @user = User.find(params[:id])
    if params[:csv_file].blank?
      redirect_to(@user, alert: 'インポートするCSVファイルを選択してください')
    else
      num = Skill.import(params[:csv_file],@user.id)
      redirect_to(@user, notice: "#{num.to_s} 件のスキルを追加 / 更新しました")
    end
  end

  def manage 
  end
  def show
    @user = User.find(params[:id])
    
    respond_to do |format|
      format.html
      format.csv { send_data @user.skills.to_csv }
    end
  end

  def drum
    @user = User.find_by_id(params[:id])
    @hot = fetch_skill(user: @user, is_hot: true, is_drum: true)
    @other = fetch_skill(user: @user, is_hot: false, is_drum: true)

    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)

    # Skill計算
    @skill_sp, @hot_sp, @other_sp, @all_sp = calc_skill(@hot, @other)

    # DBに保存
    @user.update_attributes(d: @skill_sp, dhot: @hot_sp, dother: @other_sp, dall: @all_sp)
    return if params[:rival] == nil

    # ライバル情報を取得
    @rival = User.find_by_id(params[:rival])
    if @rival == nil then
      flash[:error] = "ID" + params[:rival].to_s + "のユーザは存在しません"
      return
    end

    # スキル情報取得（ライバル）
    @hot_rival = fetch_skill(user: @rival, is_hot: true, is_drum: true)
    @other_rival = fetch_skill(user: @rival, is_hot: false, is_drum: true)
    ActiveRecord::Associations::Preloader.new.preload(@hot_rival, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other_rival, :music)

    # Skill計算(ライバル)
    @skill_sp_rival, @hot_sp_rival, @hot_other_rival, @all_sp_rival = calc_skill(@hot_rival, @other_rival)

    # 自分と相手のスキルをDBから取得して結合
    @merged_skill_hot = merge_rival_score(@hot, @hot_rival)
    @merged_skill_other = merge_rival_score(@other, @other_rival)
  end

  def guitar
    @user = User.find(params[:id])
    @hot = fetch_skill(user: @user, is_hot: true, is_drum: false)
    @other = fetch_skill(user: @user, is_hot: false, is_drum: false)

    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)

    # Skill計算
    @skill_sp, @hot_sp, @other_sp, @all_sp = calc_skill(@hot, @other)

    # DBに保存
    @user.update_attributes(g: @skill_sp, ghot: @hot_sp, gother: @other_sp, gall: @all_sp)
    return if params[:rival] == nil

    # ライバル情報を取得
    @rival = User.find_by_id(params[:rival])
    if @rival == nil then
      flash[:error] = "ID" + params[:rival].to_s + "のユーザは存在しません"
      return
    end

    # スキル情報取得（ライバル）
    @hot_rival = fetch_skill(user: @rival, is_hot: true, is_drum: false)
    @other_rival = fetch_skill(user: @rival, is_hot: false, is_drum: false)
    ActiveRecord::Associations::Preloader.new.preload(@hot_rival, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other_rival, :music)

    # Skill計算(ライバル)
    @skill_sp_rival, @hot_sp_rival, @hot_other_rival, @all_sp_rival = calc_skill(@hot_rival, @other_rival)

    # 自分と相手のスキルをDBから取得して結合
    @merged_skill_hot = merge_rival_score(@hot, @hot_rival)
    @merged_skill_other = merge_rival_score(@other, @other_rival)
   end

  def new
    @user = User.new  
  end

  def edit
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "ユーザを削除しました．"
    redirect_to users_url
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "プロフィールを更新しました．"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "アカウントが作成されました！"
      redirect_to @user
    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation, :g_comment, :d_comment, :g, :ghot, :gohter, :gall, :d, :dhot, :dother, :dall, :place)
    end

    # Before actions

    #def signed_in_user
    #  unless signed_in?
    #    store_location
    #    redirect_to signin_url, notice: "Please sign in."
    #  end
    #end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to user_path , notice: "正しいユーザでログインしてください．" unless current_user?(@user)
    end

    def fetch_skill(user:, is_hot: true, is_drum: true)
      if is_hot then
        music_id_min = 712
        music_id_max = 900
      else
        music_id_min = 1
        music_id_max = 711
      end
      if is_drum then
        music_kind_min = 0
        music_kind_max = 3
      else
        music_kind_min = 4
        music_kind_max = 11
      end
      return user.skills.find_by_sql( ['SELECT s.*
                                      FROM skills AS s
                                      WHERE s.user_id = :user_id AND
                                           (s.music_id BETWEEN :music_id_min AND :music_id_max) AND
                                           (s.kind BETWEEN :music_kind_min AND :music_kind_max)
                                      AND NOT EXISTS
                                         ( SELECT 1 FROM skills AS t
                                           WHERE s.music_id = t.music_id AND
                                                 s.user_id = t.user_id AND
                                                 s.sp < t.sp AND (t.kind BETWEEN :music_kind_min AND :music_kind_max))
                                      ORDER BY sp DESC',
                                      {user_id: user.id,
                                        music_id_min: music_id_min,
                                        music_id_max: music_id_max,
                                        music_kind_min: music_kind_min,
                                        music_kind_max: music_kind_max}]  )
    end

    # @return SP, SP(新曲のみ), SP(旧曲のみ), 全曲スキル
    def calc_skill(skill_hot, skill_other)
      hot_sp = 0.0
      hot_all = 0.0
      skill_hot.each_with_index do |h, i|
        hot_all += h.sp
        hot_sp = hot_all if i == 24
      end
      # 25曲以下の場合のSPは全曲スキルと同じ
      hot_sp = hot_all if hot_sp == 0.0

      hot_sp = hot_sp.round(2)
      hot_all = hot_all.round(2)

      other_sp = 0.0
      other_all = 0.0
      skill_other.each_with_index do |o, i|
        other_all += o.sp
        other_sp = other_all if i == 24
      end
      # 25曲以下の場合のSPは全曲スキルと同じ
      other_sp = other_all if other_sp == 0.0

      other_sp = other_sp.round(2)
      other_all = other_all.round(2)

      total_sp = (hot_sp + other_sp).round(2)
      total_all = (hot_all + other_all).round(2)
      return [total_sp, hot_sp, other_sp, total_all]
    end

    # 曲名をキーに自分とライバルのスキル情報を結合する
    def merge_rival_score(skill_me, skill_rival)
      merged_skill = {}
      skill_me.each do |skill|
        merged_skill[skill.music] = {} if merged_skill[skill.music] == nil
        merged_skill[skill.music]["me"] = skill
      end

      skill_rival.each do |skill|
        merged_skill[skill.music] = {} if merged_skill[skill.music] == nil
        merged_skill[skill.music]["rival"] = skill
      end

      merged_skill.each do |key, value|
        if value["me"] == nil then
          value["me"] = Marshal.load(Marshal.dump(value["rival"]))
          value["me"].rate = 0.0
          value["me"].sp = 0.0
          value["me"].isfc = false
          value["me"].id = -1
        elsif value["rival"] == nil then
          value["rival"] = Marshal.load(Marshal.dump(value["me"]))
          value["rival"].rate = 0.0
          value["rival"].sp = 0.0
          value["rival"].isfc = false
          value["rival"].id = -1
        end
      end
      return merged_skill
    end
end
