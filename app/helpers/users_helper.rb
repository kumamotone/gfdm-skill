module UsersHelper
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

  def fetch_sp_d(id)
    sp = Sp.find_by_user_id(id)
    sp.d
  end
  def fetch_sp_g(id)
    sp = Sp.find_by_user_id(id)
    sp.g
  end
end
