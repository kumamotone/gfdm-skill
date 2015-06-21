module ApplicationHelper
  def full_title(page_title)
    base_title = "GITADORA Tri-boost Skill Simulator"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end
  def fetch_level(music_id ,kind)
    music = Music.find(music_id)

    case kind
    when 0 then 
      music.d_bsc
    when 1 then 
      music.d_adv
    when 2 then 
      music.d_ext
    when 3 then
      music.d_mas
    end
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
      end
  end

  def show_color (kind)
    case kind
    when 0
      "info"
    when 1
      "warning"
    when 2 
      "danger"
    when 3 
      "active"
    end
  end

  def show_rank(rate, isfc)
    case rate
    when 0..63 then 
      if isfc
        'C/FC'
      else
        'C'
      end
    when 63..73 then 
      if isfc
        "B/FC"
      else
        "B"
      end
    when 73..80 then 
      if isfc
        "A/FC"
      else
        "A"
      end
    when 80..95 then 
      if isfc
        "S/FC"
      else 
        "S"
      end
    when 95..100 then 
      if isfc
        "SS/FC"
      else 
        "SS"
      end
    else 
      "EXC"
   end
 end
end
