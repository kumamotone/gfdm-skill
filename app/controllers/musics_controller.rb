class MusicsController < ApplicationController

  # GET /musics
  # GET /musics.json
  def index
    @musics = Music.all
  end

end
