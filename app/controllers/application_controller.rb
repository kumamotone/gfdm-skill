class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
    def user_root_path
        current_user
    end
  def after_sign_in_path_for(resource)
    current_user 
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end
end
