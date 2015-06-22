class UsersController < ApplicationController
  before_action :signed_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @hot = @user.skills.where(music_id: 712..756).order("sp DESC")
    @other = @user.skills.where(music_id: 1..711).order("sp DESC")# 終端位置変更の必要あり
    
    # hot計算
    @hot_sp = 0.0
    @hot.limit(25).each do |h|
      @hot_sp = @hot_sp + h.sp
    end
    
    # other計算
    @other_sp = 0.0
    @other.limit(25).each do |o|
      @other_sp = @other_sp + o.sp
    end
   
    # sp計算
    @skill_sp = @hot_sp + @other_sp
    
    # all計算
    @all_sp = 0.0
    @hot.each do |h|
      @all_sp = @all_sp + h.sp
    end
    @other.each do |o|
      @all_sp = @all_sp + o.sp
    end
  end

  def show
    @user = User.find(params[:id])
    @hot = @user.skills.where(music_id: 712..756)
    @other = @user.skills.where(music_id: 1..711) # 終端位置変更の必要あり
    #@user.skills.order("sp DESC").each do |s|
    #  music = Music.find(s.music_id)
    #  if music.ishot
    #    @hot.push(s)
    #  else
    #    @other.push(s)
    #  end
    #end
    
    hot_limit = @user.skills.where(music_id: 712..756).order("sp DESC").limit(25)
    @hot_sp = 0.0

    hot_limit.each do |h|
      @hot_sp = @hot_sp + h.sp
    end
    
    other_limit = @user.skills.where(music_id: 1..711).order("sp DESC").limit(25)
    @other_sp = 0.0

    other_limit.each do |o|
      @other_sp = @other_sp + o.sp
    end
    
    @skill_sp = @hot_sp + @other_sp
    @all_sp = @skill_sp
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
                                   :password_confirmation)
    end

    # Before actions

    #def signed_in_user
    #  unless signed_in?
    #    store_location
    #    redirect_to signin_url, notice: "Please sign in."
    #  end
    #end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end
