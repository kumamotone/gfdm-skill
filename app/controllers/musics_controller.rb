class MusicsController < ApplicationController

  # GET /musics
  # GET /musics.json
  def index
  end

  def hot
    @musics = Music.all.where(ishot: true)
  end

  def other
    @musics = Music.all.where(ishot: false)
  end
end
