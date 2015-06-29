module UsersHelper
  def fetch_sp_d(id)
    sp = Sp.find_by_user_id(id)
    sp.d
  end
  def fetch_sp_g(id)
    sp = Sp.find_by_user_id(id)
    sp.g
  end
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end

