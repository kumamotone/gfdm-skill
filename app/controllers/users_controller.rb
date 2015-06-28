class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update, :destroy, :manage, :import]
  before_action :correct_user,   only: [:edit, :update, :manage, :import]
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
    @sp = Sp.find_by_user_id(@user.id)

    if @sp.nil?
      @sp = Sp.create(user_id: @user.id, d: 0.0, dhot: 0.0, dother: 0.0, dall: 0.0, g: 0.0, ghot: 0.0, gother: 0.0, gall: 0.0) 
    end
    respond_to do |format|
      format.html
      format.csv { send_data @user.skills.to_csv }
    end
  end

  def drum
    @user = User.find(params[:id])
    @sp = Sp.find_by_user_id(@user.id)

    @hot= @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 712 AND 900) AND (s.kind BETWEEN 0 AND 3) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 0 AND 3)) ', @user.id]  )
    @other = @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 1 AND 711) AND (s.kind BETWEEN 0 AND 3) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 0 AND 3)) ', @user.id]  )
    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)
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
   
    @sp.update( d: @skill_sp, dhot: @hot_sp, dother: @other_sp, dall: @all_sp)
    @sp.save
  end

  def guitar
    @user = User.find(params[:id])
    @sp = Sp.find_by_user_id(@user.id)

    @hot= @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 712 AND 900) AND (s.kind BETWEEN 4 AND 11) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 4 AND 11)) ', @user.id]  )
    @other = @user.skills.find_by_sql( ['SELECT s.* FROM skills AS s WHERE s.user_id = ? AND (s.music_id BETWEEN 1 AND 711) AND (s.kind BETWEEN 4 AND 11) AND NOT EXISTS ( SELECT 1 FROM skills AS t WHERE s.music_id = t.music_id AND s.user_id = t.user_id AND s.sp < t.sp AND (t.kind BETWEEN 4 AND 11)) ', @user.id]  )
    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)
 
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

    @sp.g = @skill_sp
    @sp.ghot = @hot_sp
    @sp.gother = @other_sp
    @sp.gall = @all_sp
    @sp.save
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
                                   :password_confirmation, :g_comment, :d_comment, :profile, :place)
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
end
