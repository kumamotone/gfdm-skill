module UsersHelper
  def fetch_sp_d(id)
    sp = Sp.find_by_user_id(id)
    sp.d
  end
  def fetch_sp_g(id)
    sp = Sp.find_by_user_id(id)
    sp.g
  end
end
