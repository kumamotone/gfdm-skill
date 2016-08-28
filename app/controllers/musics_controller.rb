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
    entry = Music.find(params[:id])
    client = ApplicationController.helpers.get_twitter_client

    tweet_text = "曲情報が削除されました。(by @#{current_user.twitterid}) \n\n削除曲: #{entry.name}"
    if Rails.env == 'development'
      tweet_text = tweet_text + "(開発テスト)"
    end
    client.update(tweet_text)
    entry.destroy

    ApplicationController.helpers.create_max
    flash[:success] = "曲情報を削除しました．"
    redirect_to root_path
  end

  def update
    @music = Music.find(params[:id])
    @music.name.strip! unless @music.name.nil?

    # 本当はここでこれを登録しているスキルのSPを更新するとかしたほうがいい
    if @music.update_attributes(music_params)
      client = ApplicationController.helpers.get_twitter_client
      client.update("曲情報が変更されました。(by @#{current_user.twitterid}) \n\n#{@music.name} \n#{@music.d_bsc} #{@music.d_adv} #{@music.d_ext} #{@music.d_mas} \n#{@music.g_bsc} #{@music.g_adv} #{@music.g_ext} #{@music.g_mas} \n#{@music.b_bsc} #{@music.b_adv} #{@music.b_ext} #{@music.b_mas}")

      # スクリーンネームは最大15文字なので、曲名は39文字に削る
      # (一番長いと思われる 轟け!恋のビーンボール!! ～96バット砲炸裂!GITADORAシリーズMVP弾!～ で42文字なので稀に切れるはず)
      # Rails に truncate という便利ヘルパーがあるのでそれ使った方が良いかも
      tweet_text = "曲情報が変更されました。(by @%s) \n\n%.39s\nD %.2f %.2f %.2f %.2f\nG %.2f %.2f %.2f %.2f\nB %.2f %.2f %.2f %.2f" % [current_user.twitterid , @music.name, @music.d_bsc, @music.d_adv, @music.d_ext, @music.d_mas, @music.g_bsc, @music.g_adv, @music.g_ext, @music.g_mas, @music.b_bsc, @music.b_adv, @music.b_ext, @music.b_mas]
      if Rails.env == 'development'
        tweet_text = tweet_text + "(開発テスト)"
      end
      client.update(tweet_text)

      ApplicationController.helpers.create_max

      flash[:success] = "曲情報を更新しました．"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def create
    @music = Music.new(music_params)
    @music.id = Music.maximum(:id).next  # 最大の番号が削除済みの場合連番にならなくなってしまうので調整
    @music.name.strip! unless @music.name.nil?

    if @music.save
      client = ApplicationController.helpers.get_twitter_client
      # スクリーンネームは最大15文字なので、曲名は39文字に削る
      # (一番長いと思われる 轟け!恋のビーンボール!! ～96バット砲炸裂!GITADORAシリーズMVP弾!～ で42文字なので稀に切れるはず)
      # Rails に truncate という便利ヘルパーがあるのでそれ使った方が良いかも
      tweet_text = "曲情報が追加されました。(by @%s) \n\n%.39s\nD %.2f %.2f %.2f %.2f\nG %.2f %.2f %.2f %.2f\nB %.2f %.2f %.2f %.2f" % [current_user.twitterid , @music.name, @music.d_bsc, @music.d_adv, @music.d_ext, @music.d_mas, @music.g_bsc, @music.g_adv, @music.g_ext, @music.g_mas, @music.b_bsc, @music.b_adv, @music.b_ext, @music.b_mas]
      if Rails.env == 'development'
        tweet_text = tweet_text + "(開発テスト)"
      end
      client.update(tweet_text)

      ApplicationController.helpers.create_max
      flash[:success] = "曲情報が追加されました！"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def musiclist
    users = User.all
    array = []
    users.each {|user|
      array.push([user.id, user.name, user.d, user.g, user.skill_updated_at_d, user.skill_updated_at_g])
    }
    render :json => { :users => array.as_json }
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
    if current_user.admin? || current_user.subadmin?
      # pass
    else
      flash[:error] = "曲情報を変更する権限がありません。"
      redirect_to(root_path)
    end
  end
end
