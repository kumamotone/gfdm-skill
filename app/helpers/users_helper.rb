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
end
