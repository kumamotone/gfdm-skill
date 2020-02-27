class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:edit, :update, :destroy, :manage, :import]
  # before_action :correct_user,   only: [:edit, :update, :manage, :import]
  before_action :admin_user, only: :destroy

  def index
    @users = User.all
  end

  def index_old
    @users = User.all
  end

  def import
    @user = User.find(params[:id])
    if params[:csv_file].blank?
      redirect_to(@user, alert: 'インポートするCSVファイルを選択してください')
    else
      num = Skill.import(params[:csv_file], @user.id)
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
    @user = User.find(params[:id])
    @hot = fetch_skill(user: @user, is_hot: true, is_drum: true)
    @other = fetch_skill(user: @user, is_hot: false, is_drum: true)
    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)

    # 必要な情報をフェッチ
    @hot_sp = @user.dhot
    @other_sp = @user.dother
    @skill_sp = @user.d
    @all_sp = @user.dall

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

    # 必要な情報をフェッチ（ライバル）
    @hot_sp_rival = @rival.dhot
    @other_sp_rival = @rival.dother
    @skill_sp_rival = @rival.d
    @all_sp_rival = @rival.dall

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

    # 必要な情報をフェッチ
    @hot_sp = @user.ghot
    @other_sp = @user.gother
    @skill_sp = @user.g
    @all_sp = @user.gall

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

    # 必要な情報をフェッチ(ライバル)
    @hot_sp_rival = @rival.ghot
    @other_sp_rival = @rival.gother
    @skill_sp_rival = @rival.g
    @all_sp_rival = @rival.gall

    # 自分と相手のスキルをDBから取得して結合
    @merged_skill_hot = merge_rival_score(@hot, @hot_rival)
    @merged_skill_other = merge_rival_score(@other, @other_rival)
  end

  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
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
    @user.id = User.maximum(:id).next # 最大の番号が削除済みの場合連番にならなくなってしまうので調整
    if @user.save
      sign_in @user
      flash[:success] = "アカウントが作成されました！"
      redirect_to @user
    else
      render 'new'
    end
  end

  def userlist
    users = User.all
    array = []
    users.each {|user|
      array.push([user.id, user.name, user.d, user.g, user.skill_updated_at_d, user.skill_updated_at_g])
    }
    render :json => { :users => array.as_json }
  end

  def drum_average_other
    @average = calc_average(true, true)
  end

  def drum_average_hot
    @average = calc_average(true, false)
  end

  def guitar_average_other
    @average = calc_average(false, true)
  end

  def guitar_average_hot
    @average = calc_average(false, false)
  end

  def calc_average(isDrum, isOther)
    from = params[:from]
    to = params[:to]
    max_music_id = Music.maximum(:id)

    if isDrum
      users = User.where(d: from..to)
    else
      users = User.where(g: from..to)
    end

    skills = Hash.new()

    # init
    if isOther
      if isDrum
        1.upto(711){ |i|
          0.upto(3) { |j|
           skills.store([i,j], {"rates" => []})
          }
        }
      else
        1.upto(711){ |i|
          4.upto(11) { |j|
            skills.store([i,j], {"rates" => []})
          }
        }
      end
    else
      if isDrum
        712.upto(max_music_id){ |i|
          0.upto(3) { |j|
            skills.store([i,j], {"rates" => []})
          }
        }
      else
        712.upto(max_music_id){ |i|
          4.upto(11) { |j|
            skills.store([i,j], {"rates" => []})
          }
        }
      end
    end

    if isOther
      users.each { |user|
        if isDrum
          user.skills.where(music_id: 1..711, kind: 0..3).each { |skill|
          arr = skills.fetch([skill.music_id,skill.kind])
          rates = arr.fetch("rates")
          rates.push({"rate" => skill.rate, "sp" => skill.sp})
        }
        else
          user.skills.where(music_id: 1..711, kind: 4..11).each { |skill|
            arr = skills.fetch([skill.music_id,skill.kind])
            rates = arr.fetch("rates")
            rates.push({"rate" => skill.rate, "sp" => skill.sp})
          }
        end
      }
    else
      if isDrum
        users.each { |user|
        user.skills.where(music_id: 712..max_music_id, kind: 0..3).each { |skill|
          arr = skills.fetch([skill.music_id,skill.kind])
          rates = arr.fetch("rates")
          rates.push({"rate" => skill.rate, "sp" => skill.sp})
        }
      }
      else
        users.each { |user|
          user.skills.where(music_id: 712..max_music_id, kind: 4..11).each { |skill|
            arr = skills.fetch([skill.music_id,skill.kind])
            rates = arr.fetch("rates")
            rates.push({"rate" => skill.rate, "sp" => skill.sp})
          }
        }
      end
    end

    skills.delete_if {|k, v| v.fetch("rates").size == 0 }
    # skills = skills.sort_by{|k, v| v.fetch("rates").size }.reverse

    returnArr = []

    skills.each { |k,v|
      rates = v.fetch("rates")

      size = rates.size
      # v.store("size", size)

      if size != 0
        ave_rate = rates.inject(0) {|sum, item| sum + item.fetch("rate")} / size
        ave_sp = rates.inject(0) {|sum, item| sum + item.fetch("sp")} / size

        # v.store("ave_rate", ave_rate)
        # v.store("ave_sp", ave_sp)

        music = Music.find_by_id(k[0])
        if music.nil?
          # v.store("name", "deleted")
          returnArr.push([k[0], "deleted", k[1], ave_rate, ave_sp, size])
          return
        else
          # v.store("name", music.name)
          returnArr.push([k[0], music.name, k[1], ave_rate, ave_sp, size])
        end
        # v.store("kind", k[1])
      end
      # v.delete("rates")
    }

    # render :json => skills.as_json
    # render :json => { :aves => returnArr.as_json }
    return returnArr.take(200)  # 表示に時間がかかるので
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation, :g_comment, :d_comment, :g, :ghot, :gohter, :gall, :d, :dhot, :dother, :dall, :place)
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
        value["me"].kind = -1
        value["me"].rate = 0.0
        value["me"].sp = 0.0
        value["me"].isfc = false
        value["me"].id = -1
      elsif value["rival"] == nil then
        value["rival"] = Marshal.load(Marshal.dump(value["me"]))
        value["rival"].kind = -1
        value["rival"].rate = 0.0
        value["rival"].sp = 0.0
        value["rival"].isfc = false
        value["rival"].id = -1
      end
    end
    return merged_skill
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
    redirect_to user_path, notice: "正しいユーザでログインしてください．" unless current_user?(@user)
  end
end
