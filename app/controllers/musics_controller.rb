class MusicsController < ApplicationController
  #before_action :signed_in_user,     only: [:edit, :update, :create, :destroy]
  before_action :authenticate_user!, only: [:edit, :update, :create, :destroy]
  before_action :admin_user, only: [:edit, :update, :create, :destroy]

  # GET /musics
  # GET /musics.json
  def index
  end

  def show
    @music = Music.find(params[:id])
  end

  def hot
    @musics = Music.all.where(ishot: true)
  end

  def other
    @musics = Music.all.where(ishot: false)
  end

  def new
    @music = Music.new
  end

  def edit
    @music = Music.find(params[:id])
  end

  def destroy
    Music.find(params[:id]).destroy
    flash[:success] = "曲情報を削除しました．"
    redirect_to root_path
  end

  def update
    @music = Music.find(params[:id])

    # 本当はここでこれを登録しているスキルのSPを更新するとかしたほうがいい
    if @music.update_attributes(music_params)
      flash[:success] = "曲情報を更新しました．"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def create
    @music = Music.new(music_params)
    if @music.save
      flash[:success] = "曲情報が追加されました！"
      redirect_to root_path
    else
      render 'new'
    end
  end

  private

  def music_params
    params.require(:music).permit(:name, :bpm, :d_bsc, :d_adv, :d_ext, :d_mas,
                                  :g_bsc, :g_adv, :g_ext, :g_mas, :b_bsc, :b_adv, :b_ext, :b_mas, :ishot)
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
end
