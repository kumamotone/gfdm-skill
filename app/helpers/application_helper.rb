module ApplicationHelper
  def full_title(page_title)
    base_title = "GITADORA Tri-boost スキルシミュレータ"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def calc_sp(skill)
    rate = skill.rate
    level = ApplicationController.helpers.fetch_level_by_skill(skill)
    return ((rate * level * 20) * 0.01).to_d.floor(2).to_f
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
    [["BSC",0],
     ["ADV",1],
     ["EXT",2],
     ["MAS",3],
     ["BSC(G)",4],
     ["ADV(G)",5],
     ["EXT(G)",6],
     ["MAS(G)",7],
     ["BSC(B)",8],
     ["ADV(B)",9],
     ["EXT(B)",10],
     ["MAS(B)",11]]
  end

  def show_color (kind)
    case kind
    when 0,4,8
      "bsc"
    when 1,5,9
      "adv"
    when 2,6,10
      "ext"
    when 3,7,11 
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
end

