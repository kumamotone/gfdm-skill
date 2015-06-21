module ApplicationHelper
  def max_sp_drum(skill)
    return [calc_sp(skill.d_bsc, skill.music.d_bsc),
            calc_sp(skill.d_adv, skill.music.d_adv),
            calc_sp(skill.d_ext, skill.music.d_ext),
            calc_sp(skill.d_mas, skill.music.d_mas)].max
  end

  def calc_sp(rate, level)
    return (rate * level * 20).to_d.floor(2).to_f
  end
end
