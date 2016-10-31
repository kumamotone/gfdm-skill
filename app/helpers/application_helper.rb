module ApplicationHelper
  def full_title(page_title)
    base_title = "GITADORA Tri-boost スキルシミュレータ"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def get_skillcolor(sp)
    case sp
      when 0..999.99
        "0"
      when 1000..1999.99
        "1000"
      when 2000..2499.99
        "2000"
      when 2500..2999.99
        "2500"
      when 3000..3499.99
        "3000"
      when 3500..3999.99
        "3500"
      when 4000..4499.99
        "4000"
      when 4500..4999.99
        "4500"
      when 5000..5499.99
        "5000"
      when 5500..5999.99
        "5500"
      when 6000..6499.99
        "6000"
      when 6500..6999.99
        "6500"
      when 7000..7499.99
        "7000"
      when 7500..7999.99
        "7500"
      when 8000..8499.99
        "8000"
      when 8500..9999.99
        "8500"
    end
  end

  def get_skillcolor_light(sp)
    case sp
      when 0..999.99
        "c0"
      when 1000..1999.99
        "c1000"
      when 2000..2499.99
        "c2000"
      when 2500..2999.99
        "c2500"
      when 3000..3499.99
        "c3000"
      when 3500..3999.99
        "c3500"
      when 4000..4499.99
        "c4000"
      when 4500..4999.99
        "c4500"
      when 5000..5499.99
        "c5000"
      when 5500..5999.99
        "c5500"
      when 6000..6499.99
        "c6000"
      when 6500..6999.99
        "c6500"
      when 7000..7499.99
        "c7000"
      when 7500..7999.99
        "c7500"
      when 8000..8499.99
        "c8000"
      when 8500..9999.99
        "c8500"
    end
  end

  def calc_sp(skill)
    rate = skill.rate.to_s.to_d
    level = ApplicationController.helpers.fetch_level_by_skill(skill).to_s.to_d
    return ((rate * level * 20) * BigDecimal("0.01")).to_s.to_d.floor(2).to_f
  end

  def show_kind (kind)
    case kind
      when 0
        "BSC"
      when 1
        "ADV"
      when 2
        "EXT"
      when 3
        "MAS"
      when 4
        "BSC(G)"
      when 5
        "ADV(G)"
      when 6
        "EXT(G)"
      when 7
        "MAS(G)"
      when 8
        "BSC(B)"
      when 9
        "ADV(B)"
      when 10
        "EXT(B)"
      when 11
        "MAS(B)"
    end
  end

  def kind_choices
    [["BSC", 0],
     ["ADV", 1],
     ["EXT", 2],
     ["MAS", 3],
     ["BSC(G)", 4],
     ["ADV(G)", 5],
     ["EXT(G)", 6],
     ["MAS(G)", 7],
     ["BSC(B)", 8],
     ["ADV(B)", 9],
     ["EXT(B)", 10],
     ["MAS(B)", 11]]
  end

  def show_color (kind)
    case kind
      when 0, 4, 8
        "bsc"
      when 1, 5, 9
        "adv"
      when 2, 6, 10
        "ext"
      when 3, 7, 11
        "mas"
    end
  end

  def show_rank(rate, isfc)
    case rate
      when 0..62.99 then
        if isfc
          'C/FC'
        else
          'C'
        end
      when 63..72.99 then
        if isfc
          "B/FC"
        else
          "B"
        end
      when 73..79.99 then
        if isfc
          "A/FC"
        else
          "A"
        end
      when 80..94.99 then
        if isfc
          "S/FC"
        else
          "S"
        end
      when 95..99.99 then
        if isfc
          "SS/FC"
        else
          "SS"
        end
      else
        "EXC"
    end
  end

  def fetch_music_name (id)
    music = Music.find_by_id(id)
    music.name
  end


  def get_twitter_client
    require 'twitter'
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV["CONSUMER_KEY"]
      config.consumer_secret     = ENV["CONSUMER_SECRET"]
      config.access_token        = ENV["ACCESS_TOKEN"]
      config.access_token_secret = ENV["ACCESS_SECRET"]
    end

    return client
  end
end

