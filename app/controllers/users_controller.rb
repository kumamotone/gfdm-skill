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

    @hot= @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id >= 712) AND
                                          (s.kind BETWEEN 0 AND 3)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 0 AND 3))
                                     ORDER BY sp DESC', @user.id])
    @other = @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id BETWEEN 1 AND 711) AND
                                          (s.kind BETWEEN 0 AND 3)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 0 AND 3))
                                     ORDER BY sp DESC', @user.id])

    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)
    #@hot = @user.skills.where(music_id: 712..900, kind: 0..3).order("sp DESC").group("music_id").order("sp DESC")
    #@other = @user.skills.where(music_id: 1..711, kind: 0..3).order("sp DESC").group("music_id").order("sp DESC")# 終端位置変更の必要あり

    # 必要な情報をフェッチ
    @hot_sp = @user.dhot
    @other_sp = @user.dother
    @skill_sp = @user.d
    @all_sp = @user.dall
  end

  def guitar
    @user = User.find(params[:id])
    @hot= @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id >= 712) AND
                                          (s.kind BETWEEN 4 AND 11)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 4 AND 11))
                                     ORDER BY sp DESC', @user.id])
    @other = @user.skills.find_by_sql(['SELECT s.*
                                     FROM skills AS s
                                     WHERE s.user_id = ? AND
                                          (s.music_id BETWEEN 1 AND 711) AND
                                          (s.kind BETWEEN 4 AND 11)
                                     AND NOT EXISTS
                                        ( SELECT 1 FROM skills AS t
                                          WHERE s.music_id = t.music_id AND
                                                s.user_id = t.user_id AND
                                                s.sp < t.sp AND (t.kind BETWEEN 4 AND 11))
                                     ORDER BY sp DESC', @user.id])


    ActiveRecord::Associations::Preloader.new.preload(@hot, :music)
    ActiveRecord::Associations::Preloader.new.preload(@other, :music)

    #@hot = @user.skills.where(music_id: 712..900, kind: 4..11).order("sp DESC").group("music_id").order("sp DESC")
    #@other = @user.skills.where(music_id: 1..711, kind: 4..11).order("sp DESC").group("music_id").order("sp DESC") # 終端位置変更の必要あり

    # 必要な情報をフェッチ
    @hot_sp = @user.ghot
    @other_sp = @user.gother
    @skill_sp = @user.g
    @all_sp = @user.gall
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
